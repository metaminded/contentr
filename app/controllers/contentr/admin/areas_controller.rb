module Contentr
  module Admin
    class AreasController < Contentr::Admin::ApplicationController

      before_action :get_area_containing_element

      def edit
        @area_name = params[:id]
        render layout: false
      end

      def show_version
        pp = @area_containing_element.paragraphs_for_area(params[:area_id])
        h = Hash[pp.map do |paragraph|
          paragraph.for_edit if params[:version] == 'unpublished'
          s = render_to_string partial: "contentr/paragraphs/#{paragraph.class.to_s.underscore}", locals: { paragraph: paragraph }
          [paragraph.id, s]
        end]
        render json: h
      end

      private

      def get_area_containing_element
        if params[:type] == 'Contentr::ContentBlock'
          @area_containing_element = Contentr::ContentBlock.find(params[:area_containing_element_id])
        else
          @area_containing_element = Contentr::Page.find(params[:area_containing_element_id])
        end
        raise ActiveRecord::RecordNotFound.new('Not Found') if @area_containing_element.nil?
      end
    end
  end
end
