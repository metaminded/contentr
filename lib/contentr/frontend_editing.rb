module Contentr
  module FrontendEditing
    extend ActiveSupport::Concern

    included do
      helper_method :contentr_authorized?
    end

    protected

    def contentr_authorized?
      false
    end

  end
end