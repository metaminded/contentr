Rails.application.routes.draw do

  scope '/cms', :module => 'mm_cms' do
    # Admin
    namespace :admin do
      root :to => 'dashboard#index'
    end

    # Render frontend pages
    get '/(*path)' => 'pages#show', :as => 'cms'
  end

end
