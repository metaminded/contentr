module Contentr
  module Admin
    class AreasController < Contentr::Admin::ApplicationController

      def edit
        if params[:content_block_id].present?
          @area_containing_element = Contentr::ContentBlock.find(params[:content_block_id])
        else
          @area_containing_element = Page.find(params[:page_id])
        end
        @area_name = params[:id]
        render layout: false
      end
    end
  end
end
