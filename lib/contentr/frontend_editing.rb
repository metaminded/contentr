module Contentr
  module FrontendEditing
    extend ActiveSupport::Concern

    included do
      helper_method :contentr_publisher?
      helper_method :current_contentr_user
      helper_method :allowed_to_interact_with_contentr?
    end

    protected

    def contentr_publisher?
      false
    end

    def current_contentr_user
      Contentr::User.current
    end

    def allowed_to_interact_with_contentr?
      false
    end

    def contentr_authorize!(type:, object:)
      raise 'Not allowed to access!'
    end
  end
end
