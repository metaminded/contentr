# coding: utf-8

module MmCms::Liquid

  class RenderEngine

    ##
    # Setup the Liquid template engine.
    #
    def initialize(themes_path, theme_name, request)
      @themes_path = themes_path
      @theme_name  = theme_name
      @request     = request

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

      # override layout by request if available
      options[:layout] = @request.params[:__layout] if @request and @request.params[:__layout].present?

      # Load the template identified by the given template name.
      template_file    = parse_template(options[:template])
      template_content = template_file.render!(options[:assigns], { :registers => options[:registers] })
      options[:assigns]['content_for_layout'] = template_content

      # Load the Liquid layout file.
      layout_file    = parse_template(options[:layout], true)
      layout_content = layout_file.render!(options[:assigns], { :registers => options[:registers] })

      # Finally return the final result
      return layout_content
    end

    ##
    # Loads and parses the a Liquid template
    #
    def parse_template(name, layout = false)
      t = load_template(name, layout)
      return Liquid::Template.parse(t)
    end

    ##
    # Loads a Liquid template for the current account from
    # the file system.
    #
    def load_template(name, layout = false)
      raise "Illegal template name '#{name}'" unless name =~ /^[a-zA-Z0-9_]+$/

      # override theme by request if available
      theme_name = @request.params[:__theme] if @request and @request.params[:__theme].present?
      theme_path = theme_name.present? ? File.join(@themes_path, theme_name) : File.join(@themes_path, @theme_name)

      # is there localized version of the template?
      if (I18n.locale != I18n.default_locale)
        liquid_template = File.join(theme_path, layout ? "#{name}.#{I18n.locale}.layout.html" : "#{name}.#{I18n.locale}.template.html")
        return File.read(liquid_template) if File.exists?(liquid_template)
      end

      # no localized version available or using the default locale
      # lets find the default template
      liquid_template = File.join(theme_path, layout ? "#{name}.layout.html" : "#{name}.template.html")
      raise "No such template file #{liquid_template}" unless File.exists?(liquid_template)
      File.read(liquid_template)
    end
  end
end

require 'mm_cms/liquid/tags'
require 'mm_cms/liquid/filters'
require 'mm_cms/liquid/drops'