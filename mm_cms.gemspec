# coding: utf-8

require File.expand_path('../lib/mm_cms/version', __FILE__)

Gem::Specification.new do |s|
  s.add_runtime_dependency('rails', '~> 3.0.3')
  s.add_runtime_dependency('devise', '~> 1.1')
  s.add_runtime_dependency('mongoid', '~> 2.0.0.beta.20')
  s.add_runtime_dependency('mongoid-tree', '~> 0.4')
  s.add_runtime_dependency('bson_ext', '~> 1.1')
  s.add_runtime_dependency('cancan', '~> 1.4')
  s.add_runtime_dependency('haml', '~> 3.0')
  s.add_runtime_dependency('liquid', '~> 2.2')
  s.add_runtime_dependency('stringex', '~> 1.2')
  s.add_runtime_dependency('json', '~> 1.4')
  s.add_runtime_dependency('lorem', '~> 0.1')

  s.authors = ["René Sprotte", "Dr. Peter Horn"]
  s.description = %q{MmCms is a Content Management System (CMS) that plugs into any Rails application as an engine.}
  s.email = ['team@metaminded.com']
  #s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.extra_rdoc_files = ['README.mkd']
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/provideal/mm_cms'
  s.name = 'mm_cms'
  s.platform = Gem::Platform::RUBY
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = 'mm_cms'
  s.summary = %q{CMS engine for Rails}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = MmCms::VERSION
end