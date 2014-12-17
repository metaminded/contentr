require 'jquery-rails'
# require 'compass-rails'
require 'tabulatr2'
# require 'jquery-ui-rails'
# require 'carrierwave'
require 'font-awesome-rails'
require 'ancestry'

module Contentr

  class Engine < Rails::Engine
    isolate_namespace Contentr

    initializer 'contentr frontend editing' do |app|
      require 'contentr/frontend_editing'
      ActionController::Base.send :include, Contentr::FrontendEditing
      ActionController::Base.send :hide_action, [:contentr_authorize!, :contentr_authorized?]
    end

    initializer 'contentr.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Contentr::ApplicationHelper
        helper Contentr::Admin::ParagraphsHelper
        helper Contentr::Admin::ApplicationHelper
      end
    end

  end

end
