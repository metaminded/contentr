Rails.application.routes.draw do

  scope Contentr.frontend_route_prefix, :module => 'contentr' do
    # Render frontend pages
    get '/(*path)' => 'pages#show', :as => 'contentr'
  end

  namespace :contentr do
    namespace :admin do
      resources :pages do
        put 'move_below/:buddy_id', :on => :member, :action => :move_below
        put 'insert_into/(:root_page_id)', :on => :member, :action => :insert_into
        resources :paragraphs
      end
    end
  end

end
