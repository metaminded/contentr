MmCms::Application.routes.draw do

  namespace :cms do
    # Admin
    namespace :admin do
      devise_for :users, :class_name => 'Cms::User'
    end

    # Render frontend pages
    get '/*path' => 'pages#show'
    root :to => redirect('/cms/index')
  end

  root :to => 'application#index'

end
