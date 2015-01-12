#-*- mode: ruby -*-

require 'jruby/pack/dsl'

module JrubyPack

  def self.maven( parent, &block )
    JRuby::Pack::DSL.new( parent, &block )
  end

end
