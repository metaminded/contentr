# coding: utf-8

module MmCms::Liquid::Filters::AssetUrl

  def asset_url(source)
    site = @context['site']
    theme_name = site.theme_name
    if source.present? and theme_name.present?
      File.join('/', 'mm_cms', 'themes', theme_name, source)
    else
      ""
    end
  end

end

Liquid::Template.register_filter(MmCms::Liquid::Filters::AssetUrl)