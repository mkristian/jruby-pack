# packing jar/war files of ruby application #

the idea of runnable jar with a jruby application is quite interesting. <github.com/jruby/warbler> can do this.

the actual idea boils down to

* zip the application as is into a zip-file or jar-file
* add the gems into ./gems and ./specifications of that zip-file (embedded gems)
* tell jruby to use the files inside the zip-file

which is essentially something like this

```java -cp application.jar:jruby-complete.jar org.jruby.Main -S rake -T```

for this jruby just needs to change the *CWD* (current working directory) into the application.jar and execute a minimal changed org.jruby.Main

finally you could just join both jar into one and get something like:

```java -jar runnable_app.jar -S rake -T```

for packing web-archive it should be enough to pack the war file as such:

* all the staticly served files go into the root directory of the war-file
* the application (without the staticly served files) + the embedded gems
  go into WEB-INF/classes
* add jruby-complete.jar and jruby-rack.jar to WEB-INF/lib
* add the web.xml to WEB-INF

with jruby-rack-1.1.18 onwards there is support for such layout and the minimal web.xml looks like this:

```
<web-app>
  <context-param>
	<param-name>jruby.rack.layout_class</param-name>
    <param-value>JRuby::Rack::ClassPathLayout</param-value>
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

# note

currently it uses a snapshot of jruby-1.7.19-SNAPSHOT, dito the gem-maven-plugin is a snapshot. jruby-rack has an open pull request for app.root + gem.path to be uri-like pathes.

## extracting runnable jar/war files ##

when running a jar/war file it is possible to just run and load everything directly from the jar/war file. in some cases it needs to be unpacked, like some rake tasks spawn ruby which does not work when everything is packed in jar/war file. but extracting gives a few seconds on startup time of launcher !

actually running a war-file does extract the jar from WEB-INF/lib (for classloader reasons) in the same manner jetty runs unexploded war-file.

## jar with embedded gems ##

create a Mavenfile with

```
use( :jruby_pack ) do
  embedded_gems
end
```

and pack it with

```rmvn package```

or to customize it with

```
use( :jruby_pack ) do
  embedded_gems do
    without :test, :development
	include\_bin\_stubs( true )
  end
end
```

## packing jar-file ##

packing a jar-file with ruby resources and embedded gems and embedded jar (from Jarfile). this is the actually the "application.jar" from the example of the intro.

create a Mavenfile with

```
use( :jruby_pack ) do
  pack_jar
end
```

or a runnable jar-file

```
use( :jruby_pack ) do
  pack_jar do
    runnable do
      # before executing jruby the jar will be extracted to temp directory
	  extracting
	end
  end
end
```

or to customize it with

```
use( :jruby_pack ) do
  pack_jar
    runnable do
	  extracting
	  noasm # jruby with relocated ASM dependencies
	end
    includes( '${config.ru}', '.jbundler/classpath.rb',
              '*file', '*file.lock',
              'lib/**', 'app/**', 'config/**', 'vendor/**' )
    excludes
	config_ru( 'config.ru' )
	# defaults to true for runnable jar otherwise false
	include\_bin\_stubs( true )
	gem\_home 'pkg/rubygems'
  end
end
```
## paching war-file ##

packing a war-file is almost identical to packing a jar-file: just use ```pack_war`` and create a Mavenfile with

```
use( :jruby_pack ) do
  pack_war
end
```

or a runnable war-file

```
use( :jruby_pack ) do
  pack_war do
    runnable do
      # before executing jruby the jar will be extracted to temp directory
	  extracting
	end
  end
end
```

or to customize it with

```
use( :jruby_pack ) do
  pack_war do
    runnable do
	  extracting
	  noasm # jruby with relocated ASM dependencies
	end
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
