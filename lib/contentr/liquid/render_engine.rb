# coding: utf-8

module Contentr::Liquid

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
    # Renders the given page
    #
    def render_page(page, options = {})
      # Merge the options hash with some useful defaults
      options = {
        :layout    => page.layout,
        :template  => page.template,
        :assigns   => {},
        :registers => {}
      }.merge(options)

      # Load the template and extract the areas
      template_content = load_template(options[:template], 'template')
      template = Nokogiri::HTML.parse(template_content)
      areas = page.paragraphs.inject(template.xpath('//@data-cms-area').map(&:value).inject({}) do |a, area|
        a[area] = []
        a
      end) do |a, paragraph|
        a[paragraph.area_name] << paragraph if a[paragraph.area_name]
        a
      end

      # Render paragraphs
      areas.each do |area_name, paragraphs|
        nodes = template.xpath('//div[@data-cms-area="'+area_name+'"]')
        nodes[0].content = render_paragraphs(paragraphs) if nodes[0]
      end

      # Load the template identified by the given template name.
      template_file    = Liquid::Template.parse(template.to_s)
      template_content = template_file.render!(options[:assigns], { :registers => options[:registers] })
      options[:assigns]['content_for_layout'] = template_content

      # Load the Liquid layout file.
      layout_file    = parse_template(options[:layout], 'layout')
      layout_content = layout_file.render!(options[:assigns], { :registers => options[:registers] })

      # Finally return the final result
      return layout_content
    end

    ##
    # Renders the paragraphs
    #
    def render_paragraphs(paragraphs)
      paragraphs.map do |p|
        p.title + " " + p.body
      end.join("\n")
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
      raise "Illegal template type '#{type}'" unless %w(template layout include).member?(type)

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