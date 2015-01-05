# packing jar/war files of ruby application #

the idea of runnable jar with a jruby application is quite interesting. <github.com/jruby/warbler> can do this.

the actual idea boils down to

* zip the application as into a zip-file
* add the gems into ./gems and ./specifications of that zip-file (embedded gems)
* tell jruby to use the files inside the zip-file

which is essentially something like this

```java -cp application.jar:jruby-complete.jar org.jruby.Main -S rake -T```

for this jruby just needs to change the *CWD* (current working directory) into the application.jar and execute the a minimal changed org.jruby.Main

finally you could just join both jar into one and get something like:

```java -jar runnable_app.jar -S rake -T```

for packing the application into a war it should be enough to pack the war file as such:

* all the staticly served files go into the root directory of the war-file
* the application (without the staticly served files) + the embedded gems
  go into WEB-INF/classes or pack it all up in jar like above and the packed
  jar to WEB-INF/lib
* add jruby-complete.jar and jruby-rack.jar to WEB-INF/lib
* add the web.xml to WEB-INF

```
<web-app>
  <context-param>
    <param-name>app.root</param-name>
    <param-value>uri:classloader://</param-value>
  </context-param>
  <context-param>
    <param-name>gem.path</param-name>
    <param-value>uri:classloader://</param-value>
  </context-param>
  <context-param>
    <param-name>rackup</param-name>
    <param-value>eval File.read( 'uri:classloader://config.ru' )</param-value>
  </context-param>
  <filter>
    <filter-name>RackFilter</filter-name>
    <filter-class>org.jruby.rack.RackFilter</filter-class>
  </filter>
  <filter-mapping>
    <filter-name>RackFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
  <listener>
    <listener-class>org.jruby.rack.RackServletContextListener</listener-class>
  </listener>
</web-app>
```

the rackup parameter is only needed when you pack the application into jar file first but makes it easier to just launch the application totally unpacked from how it is on the file-system.

# note

currently it uses a snapshot of jruby-1.7.19-SNAPSHOT, dito the gem-maven-plugin is a snaptshot. jruby-rack has an open pull request for app.root + gem.path to be uri-like pathes.

## jar with embedded gems ##

create a Mavenfile with

```
require 'jruby_pack'

JRubyPack.maven( self ) do
  embedded_gems
end
```

and pack it with

```rmvn package```

or to customize it with

```
require 'jruby_pack'

JRubyPack.maven( self ) do
  embedded_gems do
    without :test, :development
	include\_bin\_stubs( true )
  end
end
```

## runnable jar ##

create a Mavenfile with

```
require 'jruby_pack'

JRubyPack.maven( self ) do
  runnable
end
```

and pack it with

```rmvn package```

or to customize it with

```
require 'jruby_pack'

JRubyPack.maven( self ) do
  runnable do
    includes( '${config.ru}', '.jbundler/classpath.rb',
              '*file', '*file.lock',
              'lib/**', 'app/**', 'config/**', 'vendor/**' )
    excludes
	config_ru( 'config.ru' )
	include\_bin\_stubs( true )
	gem\_home 'pkg/rubygems'
  end
end
```

## pack gems and ruby sources ##

this is exactly the same as the runnable case but without bundle jruby. which is the actually the "application.jar" from the example of the intro.

create a Mavenfile with

```
require 'jruby_pack'

JRubyPack.maven( self ) do
  pack_it
end
```

and pack it with

```rmvn package```

or to customize it with

```
require 'jruby_pack'

JRubyPack.maven( self ) do
  pack+it do
    includes( '${config.ru}', '.jbundler/classpath.rb',
              '*file', '*file.lock',
              'lib/**', 'app/**', 'config/**', 'vendor/**' )
    excludes
	config_ru( 'config.ru' )
	include\_bin\_stubs( true )
	gem\_home 'pkg/rubygems'
  end
end
```

## contributing ##

1. fork it
2. create your feature branch (`git checkout -b my-new-feature`)
3. commit your changes (`git commit -am 'Added some feature'`)
4. push to the branch (`git push origin my-new-feature`)
5. create new Pull Request

## extra-fu ##

bug-reports and pull request are most welcome. otherwise

enjoy :) 
