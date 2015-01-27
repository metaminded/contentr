module Contentr
  module Admin
    class ApplicationController < ::Contentr::ApplicationController
      include ApplicationControllerExtension

      def _contentr_confirm_access
        true
      end
    end
  end
end
