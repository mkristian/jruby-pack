#-*- mode: ruby -*-

require 'jruby/pack/base_dsl'

module JRuby
  module Pack
    class RunnableDSL < BaseDSL

      def initialize( root, parent, &block )
        @parent = parent
        parent.include_bin_stubs true
        super root
      end

      def extracting( args = true )
        @extracting = args
      end
      
      def noasm( args = true )
        @noasm = args
      end

      def init_file( file = nil )
        @init ||= file
      end

      def apply
        super
        setupMain
        setupPackaging

        root.snapshot_repository :id => 'oss', :url => 'https://oss.sonatype.org/content/repositories/snapshots/'

        root.pom "org.jruby:jruby#{@noasm ? '-noasm' : ''}:1.7.19-SNAPSHOT"

        properties[ 'bundle.without' ] = @parent.without.join( ':' )
        properties[ 'rack.env' ] = 'production'
      end
    end
  end
end
