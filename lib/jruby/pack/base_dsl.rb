#-*- mode: ruby -*-

require 'jruby/pack/runnable_dsl'

module JRuby
  module Pack
    class BaseDSL

      def initialize( parent, &block )
        @parent = parent
        instance_eval( &block ) if block
        apply
      end

      def apply
      end

      def eval_pom( file )
        file = File.expand_path( "../#{file}", __FILE__ )
        @parent.eval_pom( File.read( file ), file )
      end

      def properties
        @parent.model.properties
      end
    end
  end
end
