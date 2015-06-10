module Contentr::FrontendRouting
  def contentr_frontend_routes
    get 'pages/:slug', to: 'contentr/pages#index', as: 'contentr_page'
  end

  def contentr_frontend_routes_for(klass, &block)
    scope "#{Contentr.divider_between_page_and_children}" do
      yield if block_given?
    end
    get "#{Contentr.divider_between_page_and_children}/*args", to: 'contentr/pages#show', defaults: {klass: klass}
  end
end
