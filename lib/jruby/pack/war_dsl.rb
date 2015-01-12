#-*- mode: ruby -*-

require 'jruby/pack/jar_dsl'
require 'jruby/pack/war_runnable_dsl'

module JRuby
  module Pack
    class WarDSL < JarDSL

      def initialize( root, &block )
        super
      end

      def runnable( &block )
        WarRunnableDSL.new( root, self, &block )
      end

      def jruby_rack( version = nil )
        @jruby_rack ||= version || '1.1.14'
      end
      
      def web_xml( path = nil)
        @web_xml ||= path || 'config/web.xml'
      end

      def public_dir( path = nil)
        @public ||= path || 'public'
      end

      def jetty( version = '9.3.0.M1' )
        root.plugin( 'org.eclipse.jetty:jetty-maven-plugin', version,
                        :webAppSourceDirectory => "${public.dir}" )
      end
      
      def tomcat( version = '1.1' )
        root.plugin( 'org.codehaus.mojo:tomcat-maven-plugin', version,
                        :warSourceDirectory => '${public.dir}' )
      end
      
      def wildfly( version = '1.0.2.Final' )
        root.plugin( 'org.wildfly.plugins:wildfly-maven-plugin', version )
      end

      def config
        @config ||= { :webAppSourceDirectory => "${public.dir}",
                      :webXml => '${web.xml}' }
      end

      def apply
        root.packaging :war
        super
        root.jar( 'org.jruby.rack:jruby-rack', '${jruby.rack.version}', 
                     :exclusions => [ 'org.jruby:jruby-complete' ] )
        root.plugin :war, '2.2', config
        properties[ 'jruby.rack.version'] = jruby_rack
        properties[ 'web.xml'] = web_xml
        properties[ 'public.dir'] = public_dir
      end      
    end
  end
end
