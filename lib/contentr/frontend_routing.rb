module Contentr::FrontendRouting
  def contentr_frontend_routes
    get 'file/:slug' => 'contentr/files#show'
    get 'pages/:slug', to: 'contentr/pages#index'
  end

  def contentr_frontend_routes_for(klass, &block)
    scope 'seiten' do
      yield if block_given?
    end
    get 'seiten/*args', to: 'contentr/pages#show', defaults: {klass: klass}
  end
end
