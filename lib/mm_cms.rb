# coding: utf-8

require 'liquid'
require 'mongoid'
require 'mongoid/tree'
require 'haml'
require 'stringex'
require 'lorem'

require 'mm_cms/engine'
require 'mm_cms/liquid'
require 'mm_cms/sass'

module MmCms

  # Site name
  mattr_accessor :site_name
  @@site_name

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

  # Returns a list of available template files
  def self.template_files
    Dir.glob("#{self.theme_path}/*.template.html")
  end

  # Returns a list of available templates
  def self.templates
    template_or_layout_files_to_logical_names(self.template_files)
  end

  # Returns a list of available layout files
  def self.layout_files
    Dir.glob("#{self.theme_path}/*.layout.html")
  end

  # Returns a list of available layouts
  def self.layouts
    template_or_layout_files_to_logical_names(self.layout_files)
  end

protected

  def self.template_or_layout_files_to_logical_names(files)
    files
      .map{ |f| File.basename(f) if File.file?(f) } # basename
      .map{ |f| f unless f =~ /.*\..{2}\..*/ }      # strip i18n naming convention
      .map{ |f| f.slice(/(.[^.]+)/) if f }          # we need only the name part
      .compact                                      # get rid of nil
  end

end