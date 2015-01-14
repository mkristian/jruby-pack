#-*- mode: ruby -*-

require 'jruby/pack/runnable_dsl'

module JRuby
  module Pack
    class WarRunnableDSL < RunnableDSL

      def initialize( root, parent, &block )
        super
      end

      def setupPackaging
        root.jar 'de.saumya.mojo:jruby-mains:0.1.0-SNAPSHOT', :scope => :provided

        root.plugin :dependency, '2.5.1' do
          root.execute_goal( 'unpack-dependencies',
                             :phase => 'prepare-package',
                             :id => 'pack jruby',
                             :includeGroupIds => 'org.eclipse.jetty,de.saumya.mojo',
                             :excludes => '*, about_files/*, META-INF/*',
                             :outputDirectory => '${project.build.directory}/${project.build.finalName}' )           
        end

        @parent.config[ :archive ] = { :manifest => { :mainClass => '${jruby.main}' } }
        if init_file
          # TODO
        else
          root.resource( :directory => File.dirname( File.expand_path( __FILE__ ) ),
                         :target_path => '${project.build.directory}/${project.build.finalName}',
                         :filtering => true,
                         :includes => ['META-INF/init.rb'] )
        end
      end

      def setupMain
        prefix = @extracting ? 'Extracting' : 'War'
        properties[ 'jruby.main'] = "de.saumya.mojo.mains.#{prefix}Main"
      end
    end
  end
end
