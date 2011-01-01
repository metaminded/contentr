# coding: utf-8

require 'rails'
require 'devise'
require 'cancan'
require 'simple_form'
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

  # Reads and parses a page model description
  def self.page_model(name)
    mf = "#{Rails.root}/public/mm_cms/model/page/#{name.downcase}.yml"
    if (File.exists?(mf))
      PageModel.new(YAML.load_file(mf))
    end
  end

protected

  def self.template_or_layout_files_to_logical_names(files)
    files
      .map{ |f| File.basename(f) if File.file?(f) } # basename
      .map{ |f| f unless f =~ /.*\..{2}\..*/ }      # strip i18n naming convention
      .map{ |f| f.slice(/(.[^.]+)/) if f }          # we need only the name part
      .compact                                      # get rid of nil
  end

  class PageDataDescription
    SUPPORTED_TYPES = %w{BigDecimal Boolean Date DateTime Float Integer String Text Time}
    attr_accessor :name, :label, :description, :type, :required, :format, :min_value, :max_value

    def initialize(name, descr)
      raise "Name must be simple" unless /^[a-z_A-Z0-9]+$/.match(name)
      @name        = name
      @label       = descr['label']       || raise("Page model must specify a 'label'")
      @description = descr['description'] || raise("Page model must specify a 'description'")
      @type        = descr['type']        || raise("Page model must specify a 'type'")
      raise "Wrong type '#{@type}'" unless SUPPORTED_TYPES.member?(@type)
      @type.downcase!
      @required    = descr['required']
      @format      = descr['format'] ? Regexp.new(descr['format']) : nil
      @min_value   = descr['min_value']
      @max_value   = descr['max_value']
    end
  end

  class PageModel
    attr_reader :data_descriptions

    def initialize(model)
      @data_descriptions = model.map do |name, desc|
          PageDataDescription.new(name, desc)
      end
    end

    def get_description(name)
      @data_descriptions.each do |d|
        return d if d.name.downcase == name.downcase
      end
      nil
    end
  end

end