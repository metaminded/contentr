module Contentr

  class Engine < Rails::Engine

    initializer 'contentr rendering' do |app|
      require 'contentr/rendering'
      ActionController::Base.send :extend, Contentr::Rendering
    end

  end

end