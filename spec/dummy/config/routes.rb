Dummy::Application.routes.draw do
  resources :articles
  namespace :store do
    resources :products
  end
  #root :to => redirect("/home")
end
