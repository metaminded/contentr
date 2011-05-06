# coding: utf-8

module Contentr::LiquidSupport::Filters::Url

  def url(source)
    return "#{Contentr.frontend_route_prefix}/#{source}"
  end

end

Liquid::Template.register_filter(Contentr::LiquidSupport::Filters::Url)