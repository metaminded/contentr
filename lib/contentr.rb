# coding: utf-8

require 'rails'
require 'jquery-rails'
require 'sass'
require 'mongoid'
require 'mongoid/tree'
require 'simple_form'


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

  # Google analytics account
  mattr_accessor :google_analytics_account
  @@google_analytics_account

  # Registered paragraphs
  mattr_reader :paragraphs
  @@paragraphs = []

  # Default way to setup Contentr
  def self.setup
    yield self
  end

  # Register a new paragraph
  def self.register_paragraph(class_name, title, options = {})
    paragraphs << ParagraphConfig.new(class_name, title, options)
  end

  # Paragraph config
  class ParagraphConfig
    attr_reader :paragraph_class, :title, :options

    def initialize(paragraph_class, title, options = {})
      @paragraph_class = paragraph_class.to_s.classify.constantize
      @title = title
      @options = options
    end
  end

end

# Require contentr engine
require 'contentr/string_extensions'
require 'contentr/engine'