#-*- mode: ruby -*-

packaging :war

jar( 'org.jruby.rack:jruby-rack', '${jruby.rack.version}', 
     :exclusions => [ 'org.jruby:jruby-complete' ] )

resource do
  directory '${basedir}'
  includes [ '${config.ru}' ]
  target_path '${web.inf}'
end

plugin( :war, '2.2',
        :webAppSourceDirectory => "${basedir}",
        :webXml => 'WEB-INF/web.xml',
        :webResources => [ { :directory => '${basedir}',
                             :targetPath => 'WEB-INF',
                             :includes => [ '${config.ru}' ] } ] )
