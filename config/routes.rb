Rails.application.routes.draw do

  scope '/cms', :module => 'contentr' do
    # Render frontend pages
    get '/(*path)' => 'pages#show', :as => 'cms'
  end

end
