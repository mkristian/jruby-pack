#-*- mode: ruby -*-

gemfile

build do
  directory 'pkg'
end

gem 'bundler', '1.7.7', :scope => :provided

plugin :dependency, :phase => :package do
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

