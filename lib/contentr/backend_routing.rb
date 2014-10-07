module Contentr::BackendRouting
  def contentr_backend_routes
    scope '(:layout_type)', layout_type: /(admin)|(embedded)/, module: 'admin', as: :admin, defaults: {layout_type: 'admin'} do
      root to: 'pages#index'
      resources :pages, only: [:index, :new, :create, :edit, :update, :destroy] do
        member do
          get :publish
          get :hide
          resources :sub_pages, only: [:index] do
            collection do
              patch :reorder
            end
          end
        end
        resources :areas, only: [:edit] do
          resources :paragraphs do
            collection do
              patch 'reorder'
            end
            member do
              get 'publish'
              get 'revert'
              get 'show_version/:version', action: :show_version, as: 'show_version'
              get :display
              get :hide
            end
          end
        end
      end
      resources :files
      resources :menus
      resources :nav_points, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        collection do
          patch 'reorder'
        end
      end
      resources :page_types, only: [:new, :create, :index, :edit, :update]
      resources :content_blocks, only: [:new, :create, :edit, :update, :index] do
        resources :paragraphs, only: [:new, :create, :index], controller: 'content_block/paragraphs' do
          collection do
            patch 'reorder' => 'content_block/paragraphs#reorder'
          end
        end
      end
      resources :content_block_usages, only: [:create]
    end
  end
end
