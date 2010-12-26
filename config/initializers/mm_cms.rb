# coding: utf-8

MmCms.setup do |config|

  config.site_name = 'My Dummy Site'

  config.themes_path = File.join(Rails.root, 'public', 'mm_cms', 'themes')

  config.theme_name = 'defraction'

  config.default_page = 'home'

end