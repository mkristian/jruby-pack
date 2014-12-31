#-*- mode: ruby -*-

pom 'org.jruby:jruby', '1.7.19-SNAPSHOT'

snapshot_repository :id => 'oss', :url => 'https://oss.sonatype.org/content/repositories/snapshots/'

# TODO move into own artifact
resource do
  directory File.dirname( File.expand_path( __FILE__ ) )
  includes [ 'Main.class' ]
end

plugin :shade do
  execute_goals( 'shade', :phase => :package,
                 :id => 'pack',
                 :artifactSet => { :excludes => ['rubygems:*'] },
                 'transformers' => [ { '@implementation' => 'org.apache.maven.plugins.shade.resource.ManifestResourceTransformer',
                                       'mainClass' => 'Main' } ] )
end

profile :noasm do

  plugin :shade do
    execute_goals( 'shade', :phase => :package,
                   :id => 'pack',
                   'relocations' => [ { 'pattern' => 'org.objectweb',
                                        'shadedPattern' => 'org.jruby.org.objectweb' } ] )
  end

end
