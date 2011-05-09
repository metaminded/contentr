class Contentr::LiquidSupport::Tags::CurrentPage < Liquid::Block

  def initialize(tag_name, markup, tokens)
    super
  end

  def render(context)
    context.stack do
      request = context.registers['request']
      page = context['page'] || context.registers['page']

      if (request and page)
        if (request.env['PATH_INFO'] == File.join(Contentr.frontend_route_prefix, page.path))
          return render_all(@nodelist, context)
        end
      end
      ''
    end
  end

end

Liquid::Template.register_tag('current_page', Contentr::LiquidSupport::Tags::CurrentPage)