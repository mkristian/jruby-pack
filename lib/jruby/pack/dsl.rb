#-*- mode: ruby -*-

require 'jruby/pack/runnable_dsl'
require 'jruby/pack/embedded_gems_dsl'
require 'jruby/pack/war_dsl'

module JRuby
  module Pack
    class DSL < BaseDSL

      def initialize( parent, &block )
        super
      end

      def war( &block )
        check
        WarDSL.new( @parent, &block )
      end

      def runnable( &block )
        check
        RunnableDSL.new( @parent, &block )
      end

      def embedded_gems( &block )
        check
        EmbeddedGemsDSL.new( @parent, &block )
      end

      def pack_it( &block )
        check
        PackItDSL.new( @parent, &block )
      end

      def check
        raise "only one package type possible" if @done
        @done = true
      end
    end
  end
end
