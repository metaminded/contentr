# coding: utf-8

module Contentr::LiquidSupport::Filters::Url

  def url(source)
    return "/cms/#{source}" # FIXME: Do not hardcode the /cms prefix
  end

end

Liquid::Template.register_filter(Contentr::LiquidSupport::Filters::Url)