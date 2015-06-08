module Contentr
  module Admin
    class ApplicationController < ::Contentr::ApplicationController
      include ApplicationControllerExtension

      layout Contentr.admin_layout

      def _contentr_confirm_access
        true
      end
    end
  end
end
