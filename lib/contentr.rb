# coding: utf-8

require 'rails'
require 'jquery-rails'
require 'mongoid'
require 'mongoid/tree'
require 'stringex'


module Contentr

  # Site name
  mattr_accessor :site_name
  @@site_name

  # Default page
  mattr_accessor :default_page
  @@default_page

  # Frontend route prefix (defaults to /cms)
  mattr_accessor :frontend_route_prefix
  @@frontend_route_prefix = '/cms'

  # Default way to setup Contentr. Run rails generate mmcms:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

end

# Require contentr engine
require 'contentr/engine'