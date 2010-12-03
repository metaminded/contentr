# coding: utf-8

require 'liquid'

module MmCms::Liquid

  class RenderEngine

    ##
    # Setup the Liquid template engine.
    #
    def initialize(themes_path, theme_name)
      @themes_path = themes_path
      @theme_name  = theme_name

      Liquid::Template.file_system = Liquid::LocalFileSystem.new(@themes_path)
    end

    ##
    # Renders a Liquid template (for the current action) together
    # with a Liquid layout.
    #
    def render_template(layout, template, options = {})
      # Merge the options hash with some useful defaults
      options = {
        :layout    => layout,
        :template  => template,
        :assigns   => {},
        :registers => {}
      }.merge(options)

      # Load the template identified by the given template name.
      template_file    = parse_template(options[:template], 'template')
      template_content = template_file.render!(options[:assigns], { :registers => options[:registers] })
      options[:assigns]['content_for_layout'] = template_content

      # Load the Liquid layout file.
      layout_file    = parse_template(options[:layout], 'layout')
      layout_content = layout_file.render!(options[:assigns], { :registers => options[:registers] })

      # Finally return the final result
      return layout_content
    end

    ##
    # Loads and parses the a Liquid template
    #
    def parse_template(name, type = 'template')
      t = load_template(name, type)
      return Liquid::Template.parse(t)
    end

    ##
    # Loads a Liquid template for the current account from
    # the file system.
    #
    def load_template(name, type = 'template')
      raise "Illegal template name '#{name}'" unless name =~ /^[a-zA-Z0-9_]+$/
      raise "Illegal template type '#{type}'" unless %w(template layout).member?(type)

      theme_path = File.join(@themes_path, @theme_name)

      # is there localized version of the template?
      if (I18n.locale != I18n.default_locale)
        liquid_template = File.join(theme_path, "#{name}.#{I18n.locale}.#{type}.html")
        return File.read(liquid_template) if File.exists?(liquid_template)
      end

      # no localized version available or using the default locale
      # lets find the default template
      liquid_template = File.join(theme_path, "#{name}.#{type}.html")
      raise "No such template file #{liquid_template}" unless File.exists?(liquid_template)
      File.read(liquid_template)
    end
  end
end

require 'mm_cms/liquid/tags'
require 'mm_cms/liquid/filters'
require 'mm_cms/liquid/drops'