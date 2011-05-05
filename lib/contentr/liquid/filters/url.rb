# coding: utf-8

module Contentr::Liquid::Filters::Url

  def url(source)
    return "/cms/#{source}" # FIXME: Do not hardcode the /cms prefix
  end

end

Liquid::Template.register_filter(Contentr::Liquid::Filters::Url)