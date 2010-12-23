# coding: utf-8

require 'rails'
require 'devise'
require 'cancan'
require 'mongoid'
require 'mongoid/tree'
require 'haml'
require 'stringex'
require 'json'

require 'mm_cms/version'
require 'mm_cms/engine'
require 'mm_cms/liquid'
require 'mm_cms/sass'

module MmCms

  # Themes path
  mattr_accessor :themes_path
  @@themes_path

  # Theme name
  mattr_accessor :theme_name
  @@theme_name

  # Default page
  mattr_accessor :default_page
  @@default_page

  # Default way to setup MmCms. Run rails generate mmcms:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  # The path to the configured theme
  def self.theme_path
    File.join(self.themes_path, theme_name)
  end

end