Rails.application.routes.draw do

  # admin
  namespace :contentr do
    namespace :admin do
      root to: 'pages#index'
      resources :pages

      resources :sites

      resources :files

      put    'pages/:page_id/area/:area_name/paragraphs/reorder'     => 'paragraphs#reorder', :as => 'reorder_paragraphs'
      get    'pages/:page_id/area/:area_name/paragraphs/(:type)/new' => 'paragraphs#new',     :as => 'new_paragraph'
      post   'pages/:page_id/area/:area_name/paragraphs/:type'       => 'paragraphs#create',  :as => 'paragraphs'

      get    'pages/:page_id/paragraphs'           => 'paragraphs#index',   :as => 'page_paragraphs'
      get    'pages/:page_id/paragraphs/:id/edit'  => 'paragraphs#edit',    :as => 'edit_paragraph'
      get    'pages/:page_id/paragraphs/:id/publish' => 'paragraphs#publish', :as => 'publish_paragraph'
      get    'pages/:page_id/paragraphs/:id/revert' => 'paragraphs#revert', :as => 'revert_paragraph'
      get    'pages/:page_id/paragraphs/:id/show_version/:current' => 'paragraphs#show_version', as: 'show_version'
      put    'pages/:page_id/paragraphs/:id'       => 'paragraphs#update',  :as => 'paragraph'
      delete 'pages/:page_id/paragraphs/:id'       => 'paragraphs#destroy', :as => 'paragraph'
    end
  end

  # frontend
  get 'file/:slug' => 'contentr/files#show'
  get '*contentr_path' => 'contentr/pages#show', :as => 'contentr'
end
