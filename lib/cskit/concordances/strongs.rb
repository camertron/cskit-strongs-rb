# encoding: UTF-8

require 'cskit'
require 'cskit/bible/kjv'
require 'cskit-strongs'

CSKit.register_annotator({
  :type => :concordance,
  :id => :strongs,
  :name => "Strong's Exhaustive Concordance of the Bible",
  :author => "James Strong",
  :language => "English",
  :volumes => [CSKit::Bible::Kjv::Volume],
  :annotator => CSKitStrongs::Annotator
})
