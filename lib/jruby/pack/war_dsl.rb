#-*- mode: ruby -*-

require 'jruby/pack/pack_it_dsl'

module JRuby
  module Pack
    class WarDSL < PackItDSL

      def initialize( parent, &block )
        super
      end

      def jruby_rack( version = nil )
        @jruby_rack ||= version || '1.1.14'
      end
      
      def web_inf( path = nil)
        @web_inf ||= path || 'WEB-INF'
      end

      def jetty( version = '9.3.0.M1' )
        @parent.plugin( 'org.eclipse.jetty:jetty-maven-plugin', version,
                        :webAppSourceDirectory => "${basedir}" )
      end
      
      def tomcat( version = '1.1' )
        @parent.plugin( 'org.codehaus.mojo:tomcat-maven-plugin', version,
                        :warSourceDirectory => '${basedir}' )
      end
      
      def wildfly( version = '1.0.2.Final' )
        @parent.plugin( 'org.wildfly.plugins:wildfly-maven-plugin', version )
      end
      
      def apply
        super
        eval_pom( "war_pom.rb" )
        properties[ 'jruby.rack.version'] = jruby_rack
        properties[ 'web.inf'] = web_inf
      end      
    end
  end
end
