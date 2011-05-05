# coding: utf-8

module Contentr::LiquidSupport::Filters::AssetUrl

  def asset_url(source)
    theme_name = @context['theme_name']
    if source.present? and theme_name.present?
      baseurl  = File.join('contentr', 'themes', theme_name)
      basepath = File.join(Rails.root, 'public', baseurl)
      path     = source

      if (I18n.locale != I18n.default_locale)
        dirname  = File.dirname(path)
        extname  = File.extname(path)
        filename = File.basename(path, extname)
        lfilename = "#{filename}.#{I18n.locale}#{extname}"
        file = File.join(basepath, dirname, lfilename)
        return File.join('/', baseurl, dirname, lfilename) if File.exists?(file)
      end

      File.join('/', baseurl, path)
    else
      ""
    end
  end

end

Liquid::Template.register_filter(Contentr::LiquidSupport::Filters::AssetUrl)