class Contentr::LiquidSupport::Tags::HasArea < Liquid::Block

  def initialize(tag_name, markup, tokens)
    if markup =~ /(#{Liquid::QuotedFragment}+)/
      @area_name = $1
    else
      raise SyntaxError.new("Error in tag 'include' - Valid syntax: has_area '[area name]'")
    end

    super
  end

  def render(context)
    context.stack do
      page = context.registers['page']
      if (page and page.expected_areas.include?(@area_name))
        return render_all(@nodelist, context)
      end
      ''
    end
  end
end

Liquid::Template.register_tag('has_area', Contentr::LiquidSupport::Tags::HasArea)