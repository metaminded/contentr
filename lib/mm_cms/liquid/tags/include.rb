module MmCms::Liquid::Tags
  class Include < ::Liquid::Include

    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens)
    end

    def render(context)
      site    = context.registers['site']
      request = context.registers['request']
      liquid  = MmCms::Liquid::RenderEngine.new(site.themes_path, site.theme_name, request)

      partial = liquid.get_liquid_template(@template_name)
      partial.render(context)
    end
  end

  ::Liquid::Template.register_tag('include', Include)
end