Dummy::Application.routes.draw do
  resources :articles
  root :to => redirect("/cms/home")
end
