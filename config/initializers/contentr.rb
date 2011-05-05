# coding: utf-8

Contentr.setup do |config|
  config.site_name    = 'My Dummy Site'
  config.themes_path  = File.join(Rails.root, 'contentr', 'themes')
  config.theme_name   = 'default'
  config.default_page = 'home'
end