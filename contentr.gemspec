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

  s.add_dependency 'rake',           '~> 0.9.2.2'
  s.add_dependency 'rails',          '> 3.2'
  s.add_dependency 'simple_form',    '~> 2.0.0'
  s.add_dependency 'bson_ext',       '~> 1.5'
  s.add_dependency 'compass-rails',  '~> 1.0.0.rc.3'
  s.add_dependency 'sass-rails'
  s.add_dependency 'bootstrap-sass', '> 2.1'
  s.add_dependency 'ancestry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'factory_girl_rails', "~> 4.0"
  s.add_development_dependency 'database_cleaner'
end
