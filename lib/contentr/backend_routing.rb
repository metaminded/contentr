module Contentr::BackendRouting
  def contentr_backend_routes
    scope 'admin', module: 'admin', as: :admin do
      root to: 'pages#index'

      resources :areas, only: [:edit], path: 'areas/:type/:area_containing_element_id' do
        resources :paragraphs, only: [:new, :create, :index] do
          collection do
            patch 'reorder'
          end
        end
        get 'show_version/:version', action: :show_version, as: 'show_version'
      end

      resources :paragraphs, except: [:new, :create, :index] do
        member do
          get 'publish'
          get 'revert'
          get 'show_version/:version', action: :show_version, as: 'show_version'
          get :display
          get :hide
          get :copy
        end
      end

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
      end
      resources :menus
      resources :nav_points, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        collection do
          patch 'reorder'
        end
      end
      resources :page_types, only: [:new, :create, :index, :edit, :update]
      resources :content_blocks, only: [:new, :create, :edit, :update, :index, :destroy]
      resources :content_block_usages, only: [:create]
    end
  end
end
