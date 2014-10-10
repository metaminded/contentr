module Contentr
  module FrontendEditing
    extend ActiveSupport::Concern

    included do
      helper_method :contentr_publisher?
      helper_method :current_contentr_user
    end

    protected

    def contentr_publisher?
      false
    end

    def current_contentr_user
      Contentr::User.current
    end

  end
end
