# coding: utf-8

Gem::Specification.new do |s|
  s.name = 'contentr'
  s.version = '0.1.0'
  s.summary = %q{CMS engine for Rails}
  s.description = %q{Contentr is a Content Management System (CMS) that plugs into any Rails 3.1 application as an engine.}
  s.authors = ["Rene Sprotte", "Dr. Peter Horn"]
  s.email = ['team@metaminded.com']
  s.homepage = 'http://github.com/metaminded/contentr'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency('rails', '> 3.1')
  s.add_dependency('simple_form', '~> 1.5')
  s.add_dependency('mongoid', '~> 2.4')
  s.add_dependency('mongoid-tree', '~> 0.6')
  s.add_dependency('bson_ext', '~> 1.5')
  s.add_dependency('compass', '> 0.12.alpha.0')
end
