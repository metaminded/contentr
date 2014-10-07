module Contentr
  module Admin
    class AreasController < ApplicationController

      def edit
        if params[:content_block_id].present?
          @page = Contentr::ContentBlock.find(params[:content_block_id])
        else
          @page = Page.find(params[:page_id])
        end
        @area_name = params[:id]
        render layout: false
      end
    end
  end
end
