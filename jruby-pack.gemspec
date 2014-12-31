#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'jruby-pack'
  s.version = '0.1.0'

  s.summary = 'pack various jar archives'
  s.description = <<-END
embed gems into a jar. create a runnable jar with all the ruby resouces. create a war file, run jetty, tomcat or wildfly. etc
END

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']
  s.homepage = 'https://github.com/mkristian/jruby-pack'

  s.license = 'MIT'

  s.files += Dir['lib/**/*.rb']
  s.files += Dir['lib/**/*.class']
  s.files += Dir['MIT-LICENSE']
  s.files += Dir['*.md']
  s.files += Dir['Gemfile*']

  s.add_runtime_dependency "ruby-maven", "~> 3.1.1"
end
