#-*- mode: ruby -*-

gemfile

build do
  directory 'pkg'
end

gem 'bundler', '${bundler.version}'#, :scope => :provided

plugin! :dependency, '2.5.1', :phase => :package do
  items = []
  File.read( 'Jarfile.lock' ).each_line do |l|
    data = l.strip.split(':')
    data = Hash[ [:groupId, :artifactId, :type, :version, :classifier].zip( data ) ]
    data[ :outputDirectory ] = File.join( '${project.build.outputDirectory}',
                                          data[:groupId].gsub(/[.]/, '/'),
                                          data[:artifactId],
                                          data[:version] )
    items << data
  end
  execute_goal( :copy,
                :id => 'copy jar dependencies',
                :artifactItems => items )
end

