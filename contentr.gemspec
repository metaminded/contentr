# coding: utf-8

Gem::Specification.new do |s|
  s.name = 'contentr'
  s.version = '0.0.2'
  s.summary = %q{CMS engine for Rails}
  s.description = %q{Contentr is a Content Management System (CMS) that plugs into any Rails application as an engine.}
  s.authors = ["René Sprotte", "Dr. Peter Horn"]
  s.email = ['team@metaminded.com']
  s.homepage = 'http://github.com/provideal/contentr'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.extra_rdoc_files = ['README.mkd']

  #s.platform = Gem::Platform::RUBY
  #s.rdoc_options = ['--charset=UTF-8']
  #s.require_paths = ['lib']
  #s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  #s.rubyforge_project = 'contentr'

  s.add_runtime_dependency('rails', '~> 3.0')

  s.add_dependency('liquid', '~> 2.2')
  s.add_dependency('mongoid', '~> 2.0')
  s.add_dependency('bson_ext', '~> 1.3')
  s.add_dependency('mongoid-tree', '~> 0.6')
  s.add_dependency('stringex', '~> 1.2')
  s.add_dependency('lorem', '~> 0.1')
  s.add_dependency('nokogiri', '~> 1.4')
end