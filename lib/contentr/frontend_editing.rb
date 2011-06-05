module Contentr
  module FrontendEditing

    def contentr_editable?
      ActiveSupport::Deprecation.warn "contentr_editable? is deprecated. " <<
        "Please use contentr_authorized? instead"
      contentr_authorized?
    end

    def contentr_authorized?
      false
    end

  end
end