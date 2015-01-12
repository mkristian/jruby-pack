#-*- mode: ruby -*-

module JRuby
  module Pack
    class BaseDSL

      def initialize( root, &block )
        @root = root
        instance_eval( &block ) if block
        apply
      end

      attr_reader :root

      def apply
      end

      def mavenfile( file )
        file = File.expand_path( "../#{file}", __FILE__ )
        root.mavenfile( file )
      end

      def properties
        root.model.properties
      end
    end
  end
end
