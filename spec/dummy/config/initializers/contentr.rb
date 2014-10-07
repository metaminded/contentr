# coding: utf-8

ActionDispatch::Routing::Mapper.send(:include, Contentr::BackendRouting)
ActionDispatch::Routing::Mapper.send(:include, Contentr::FrontendRouting)

Contentr.setup do |config|
  config.site_name    = 'My Dummy Site'
  config.default_page = 'home'
  config.default_areas = [:headline, :body]
  config.generated_page_areas = [:before_generated_content, :after_generated_content]
  config.available_grouped_nav_points = ['All articles']
  config.divider_between_page_and_children = 'seiten'
  # config.default_site = 'cms'
  # config.google_analytics_account = ''
  # config.register_paragraph(Contentr::HtmlParagraph, 'Show some raw HTML content')
end
