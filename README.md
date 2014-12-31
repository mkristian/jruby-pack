# packing jar/war files of ruby application #

the idea of runnable jar with a jruby application is quite interesting. <github.com/jruby/warbler> can do this.

when I look at the idea, it boils down to

* zip the application as into a zip-file
* tell jruby to use the files inside the zip-file

which is essentially something like this

```java -cp application.jar:jruby-complete.jar org.jruby.Main -S rake -T```

for this jruby just needs to change the *CWD* (current working directory) into the application.jar. finally you could just join both jar into one and get something like:

```java -jar runnable_app.jar -S rake -T```

# note

currently it uses a snapshot of jruby-1.7.19-SNAPSHOT, dito the gem-maven-plugin is a snaptshot.

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
