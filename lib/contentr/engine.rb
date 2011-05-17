module Contentr

  class Engine < Rails::Engine
    initializer 'static assets' do |app|
      app.middleware.use(::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'contentr rendering' do |app|
      ActionController::Base.send :extend, Contentr::Rendering
    end

    initializer 'contentr view helpers' do |app|
      ActionView::Base.send :include, Contentr::Rendering::ViewHelpers
    end
  end

end