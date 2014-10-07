Dummy::Application.routes.draw do
  if Rails.env.test?
    slugs = [:en]
  else
    slugs = Contentr::Site.table_exists? ? Contentr::Site.pluck(:slug) : [:en]
  end
  scope ':locale', locale: /#{slugs.join("|")}/ do
    resources :articles do
      member do
        get 'seiten/*args', to: 'contentr/pages#show', defaults: {klass: 'Article'}
      end
    end
  end
  namespace :store do
    resources :products
  end
  contentr_frontend_routes
  mount Contentr::Engine, at: 'contentr'
  #root :to => redirect("/home")
end
