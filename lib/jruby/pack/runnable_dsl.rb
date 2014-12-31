#-*- mode: ruby -*-

require 'jruby/pack/pack_it_dsl'

module JRuby
  module Pack
    class RunnableDSL < PackItDSL

      def initialize( parent, &block )
        @include_bin = true
        super
      end

      def apply
        super
        eval_pom( "runnable_pom.rb" )
      end
    end
  end
end
