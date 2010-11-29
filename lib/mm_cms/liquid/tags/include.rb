module MmCms::Liquid::Tags
  class Include < ::Liquid::Tag

    Syntax = /(#{::Liquid::QuotedFragment}+)/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @template_name = $1
        @attributes    = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        raise SyntaxError.new("Error in tag 'include' - Valid syntax: include '[template]'")
      end

      super
    end

    def render(context)
      site    = context.registers['site']
      request = context.registers['request']

      if (site and request)
        liquid  = MmCms::Liquid::RenderEngine.new(site.themes_path, site.theme_name, request)
        partial = liquid.parse_template(@template_name)
        context.stack do
          @attributes.each do |key, value|
            context[key] = context[value]
          end

          partial.render(context)
        end
      end
    end
  end

  ::Liquid::Template.register_tag('include', Include)
end