module Contentr

  class Engine < Rails::Engine

    initializer 'contentr rendering' do |app|
      ActionController::Base.send :extend, Contentr::Rendering
    end

    initializer 'contentr view helpers' do |app|
      ActionView::Base.send :include, Contentr::Rendering::ViewHelpers
    end

  end

end