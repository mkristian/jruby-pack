#-*- mode: ruby -*-

require 'jruby/pack/dsl'

module JRubyPack

  def self.maven( parent, &block )
    JRuby::Pack::DSL.new( parent, &block )
  end

end
