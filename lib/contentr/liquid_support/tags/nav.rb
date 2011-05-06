class Contentr::LiquidSupport::Tags::Nav < Liquid::Block

  def initialize(tag_name, markup, tokens)
    if markup =~ /for\s+(#{::Liquid::QuotedFragment}+)/
      @page_name = $1
    else
      @page_name = nil
    end

    super
  end

  def render(context)
    current_page = context[@page_name]
    pages = []
    if (current_page.present?)
      pages = current_page.children.asc(:position)
    else
      pages = Contentr::Page.roots.asc(:position)
    end

    result = []
    context.stack do
      pages.each do |p|
        context['page'] = p
        result << render_all(@nodelist, context)
      end
    end

    result
  end

end

Liquid::Template.register_tag('nav', Contentr::LiquidSupport::Tags::Nav)