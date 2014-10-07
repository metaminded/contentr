module Contentr
  module FrontendEditing
    extend ActiveSupport::Concern

    included do
      helper_method :contentr_publisher?
    end

    protected
    
    def contentr_publisher?
      false
    end

  end
end
