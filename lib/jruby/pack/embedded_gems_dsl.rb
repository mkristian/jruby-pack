#-*- mode: ruby -*-

require 'jruby/pack/base_dsl'

module JRuby
  module Pack
    class EmbeddedGemsDSL < BaseDSL

      def initialize( parent, &block )
        super
      end

      def include_bin_stubs( args = true )
        @include_bin = args
      end
      
      def bundler_version( version = nil )
        @bundler ||= version || '1.7.11'
      end

      def gem_home( home = nil )
        if home.nil?
          @gem_home ||= '${project.build.directory}/rubygems'
        else
          @gem_home = home
        end
      end

      def without( *groups )
        if groups.empty?
          @without ||= [:development, :test, :assets]
        else
          @without = groups
        end        
      end

      def setup_gem_plugin
        homes = {}
        homes[:provided] = '${gem.home}' unless without.member?(:development)
        homes[:test] = '${gem.home}' unless without.member?(:test)
        config[ :gemHomes ] = homes
        config[ :includeRubygemsInResources ] = true #unless groups.empty?
        config[ :includeBinStubs ] = @include_bin unless @include_bin.nil?

        root.jruby_plugin!( :gem, config ) do
          root.execute_goals( 'generate-resources', 'process-resources', :id => 'jruby-pack-resources' )
        end
      end

      def config
        @config ||= {} 
      end

      def apply
        mavenfile( "embedded_gems_pom.rb" )
        properties[ 'jruby.plugins.version'] = '1.0.8-SNAPSHOT'
        properties[ 'bundler.version'] = bundler_version
        properties[ 'gem.home' ] = gem_home
        setup_gem_plugin
      end      
    end
  end
end
