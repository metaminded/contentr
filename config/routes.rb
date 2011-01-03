Rails.application.routes.draw do

  scope '/cms', :module => 'mm_cms' do
    # Admin
    namespace :admin do
      match 'dashboard' => 'dashboard#index'
      resources 'pages' do
        collection do
          get 'navigation'
        end

        member do
          put 'reorder'
          put 'set_template'
        end
      end
      match 'templates' => 'templates#index'
      root :to => redirect { |params, request| "#{request.fullpath}/dashboard" }
    end

    # Render frontend pages
    get '/(*path)' => 'pages#show', :as => 'cms'
  end

end
