class Contentr::Liquid::Tags::Breadcrumb < ::Liquid::Block

  Syntax = /for\s+(#{::Liquid::QuotedFragment}+)/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @page_name = $1
    else
      @page_name = nil
    end

    super
  end

  def render(context)
    current_page = context.registers["page"]
    pages = []
    if (current_page.present?)
      pages = current_page.ancestors_and_self.to_a
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

::Liquid::Template.register_tag('breadcrumb', Contentr::Liquid::Tags::Breadcrumb)