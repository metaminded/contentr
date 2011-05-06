# coding: utf-8

module Contentr

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
    def render_page(page, request, options = {})
      # Merge the options hash with some useful defaults
      options = {
        :layout    => page.layout,
        :template  => page.template,
        :assigns   => {
          'page'       => page,
          'theme_name' => @theme_name
        },
        :registers => {
          'page'          => page,
          'render_engine' => self,
          'theme_name'    => @theme_name,
          'request'       => request
        }
      }.deep_merge(options)

      # Load the template and extract the areas
      template = load_file(options[:template], :type => 'template')
      template = Nokogiri::XML("<root>#{template}</root>") do |config|
        # defaults
      end
      areas = page.paragraphs.inject(template.xpath('//@data-contentr-area').map(&:value).inject({}) do |a, area|
        a[area] = []
        a
      end) do |a, paragraph|
        a[paragraph.area_name] << paragraph if a[paragraph.area_name]
        a
      end

      # Render paragraphs inside the page template
      areas.each do |area_name, paragraphs|
        nodes = template.xpath('//div[@data-contentr-area="'+area_name+'"]')
        next unless nodes[0]

        nodes[0].content = nil      # remove all content (e.g. dummy data) from the area node
        nodes[0] << nodes[0].parse( # parse the returned xml into a node, as content will otherwise beeing escaped
          paragraphs.map do |p|
            filename = p.class.name.underscore.split('/').last
            if (filename)
              paragraph_template = load_file(filename, :type => 'paragraph')
              paragraph_template = Liquid::Template.parse(paragraph_template)
              content = paragraph_template.render!(options[:assigns].merge({'paragraph' => p}), { :registers => options[:registers] })
              content.html_safe
            end
          end.join("")
        )
      end

      # Render the page template
      template = Liquid::Template.parse(template.root.children.to_s)
      content  = template.render!(options[:assigns], { :registers => options[:registers] })
      options[:assigns]['content_for_layout'] = content

      # Render the layout (a layout wraps the template)
      layout = load_file(options[:layout], :type => 'layout')
      layout = Liquid::Template.parse(layout)
      content = layout.render!(options[:assigns], { :registers => options[:registers] })

      # Finally return the content
      return content
    end

    ##
    # Loads a Liquid template for the current account from
    # the file system.
    #
    def load_file(name, options = {:type => 'template'})
      raise "Illegal template name '#{name}'" unless name =~ /^[a-zA-Z0-9_]+$/
      raise "Illegal template type '#{options[:type]}'" unless %w(template layout include paragraph).member?(options[:type])

      type = options[:type]
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