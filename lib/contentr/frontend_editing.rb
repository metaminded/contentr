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

    def contentr_authorized?(type: nil, object: nil)
      false
    end

    def contentr_authorize!(type: nil, object: nil)
      raise 'Not allowed to access!' unless contentr_authorized?(type: type, object: object)
    end
  end
end
