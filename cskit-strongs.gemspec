# encoding: UTF-8

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'cskit-strongs/version'

Gem::Specification.new do |s|
  s.name     = 'cskit-strongs'
  s.version  = ::CSKitStrongs::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron/cskit-strongs-rb'

  s.description = s.summary = "Strong's Concordance resources for CSKit."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'json'
  s.add_dependency 'cskit', '~> 1.1'
  s.add_dependency 'cskit-biblekjv', '~> 2.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'nokogiri'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec,resources}/**/*", "Gemfile", "History.txt", "LICENSE", "README.md", "Rakefile", "cskit-strongs.gemspec"]
end
