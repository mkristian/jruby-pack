#-*- mode: ruby -*-

require 'jruby/pack/embedded_gems_dsl'

module JRuby
  module Pack
    class PackItDSL < EmbeddedGemsDSL

      def initialize( parent, &block )
        super
      end

      def config_ru( file = nil )
        @config_ru ||= ( file || 'config.ru' )
      end

      def includes( *args )
        if args.empty?
          @includes ||= [ '${config.ru}', '.jbundler/classpath.rb',
                          '*file', '*file.lock',
                          'lib/**', 'app/**', 'config/**', 'vendor/**' ]
        else
          @includes = args
        end
      end

      def excludes( *args )
        if args.empty?
          @excludes ||= []
        else
          @excludes = args
        end
      end
      
      def setup_gem_plugin
        config[ :includeRubyResources ] = includes unless includes.empty?
        config[ :excludeRubyResources ] = excludes unless excludes.empty?
        super
      end
      
      def apply
        super
        properties[ 'config.ru'] = config_ru
      end
    end
  end
end
