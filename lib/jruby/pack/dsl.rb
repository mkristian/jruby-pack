#-*- mode: ruby -*-

require 'jruby/pack/jar_dsl'
require 'jruby/pack/embedded_gems_dsl'
require 'jruby/pack/war_dsl'

module JRuby
  module Pack
    class DSL < BaseDSL

      def initialize( root, &block )
        super
      end

      def pack_war( &block )
        check
        WarDSL.new( root, &block )
      end

      def embedded_gems( &block )
        check
        EmbeddedGemsDSL.new( root, &block )
      end

      def pack_jar( &block )
        check
        JarDSL.new( root, &block )
      end

      def check
        raise "only one package type possible" if @done
        @done = true
      end
    end
  end
end
