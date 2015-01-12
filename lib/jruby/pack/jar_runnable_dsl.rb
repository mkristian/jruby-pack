#-*- mode: ruby -*-

require 'jruby/pack/runnable_dsl'

module JRuby
  module Pack
    class JarRunnableDSL < RunnableDSL

      def initialize( root, parent, &block )
        super
      end

      def setupPackaging
        shade_config = { :phase => :package,
          :id => 'pack',
          :artifactSet => { :excludes => ['rubygems:*'] },
          :transformers => [ { '@implementation' => 'org.apache.maven.plugins.shade.resource.ManifestResourceTransformer',
                               'mainClass' => '${jruby.main}' } ] }
        root.plugin :shade, '2.2' do
          root.execute_goals( 'shade', shade_config )
        end

        root.jar 'de.saumya.mojo:jruby-mains:0.1.0-SNAPSHOT'

        if init_file
          # TODO
        else
          root.resource( :directory => File.dirname( File.expand_path( __FILE__ ) ),
                         :filtering => true,
                         :includes => ['META-INF/init.rb'] )
        end
      end

      def setupMain
        prefix = @extracting ? 'ExtractingJar' : 'Jar'
        properties[ 'jruby.main'] = "de.saumya.mojo.mains.#{prefix}Main"
      end
    end
  end
end
