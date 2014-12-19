# coding: utf-8

require 'rails'
require 'simple_form'
require 'form_translation'
require 'cancan'
require 'tabulatr'
require 'request_store'

module Contentr

  # Site name
  mattr_accessor :site_name
  @@site_name

  # Default page
  mattr_accessor :default_page
  @@default_page

  # Default site (defaults to cms)
  mattr_accessor :default_site
  @@default_site = 'cms'

  # Google analytics account
  mattr_accessor :google_analytics_account
  @@google_analytics_account

  # Registered paragraphs
  mattr_reader :paragraphs
  @@paragraphs = []

  # Additional StyleSheets for Contentr Admin
  mattr_reader :additional_admin_stylesheets
  @@additional_admin_stylesheets = []

  # Additional JavaScripts for Contentr Admin
  mattr_reader :additional_admin_javascripts
  @@additional_admin_javascripts = []

  mattr_accessor :default_areas
  @@default_areas = []

  mattr_accessor :generated_page_areas
  @@generated_page_areas = []

  mattr_accessor :available_grouped_nav_points
  @@available_grouped_nav_points = []

  mattr_accessor :divider_between_page_and_children
  @@divider_between_page_and_children = ''

  mattr_accessor :layout_type

  mattr_accessor :admin_layout
  @@admin_layout = 'application'
  mattr_accessor :embedded_admin_layout
  @@admin_layout = 'application'

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
require 'contentr/backend_routing'
require 'contentr/frontend_routing'
require 'contentr/ext/action_controller'
