module Contentr

  class Engine < Rails::Engine
    initializer 'static assets' do |app|
      app.middleware.use(::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'view helper' do |app|
      ActionView::Base.send :include, Contentr::RenderSupport
    end
  end

end