# encoding: utf-8
module Contentr
  module Admin
    class ParagraphsController < Contentr::Admin::ApplicationController
      include ::Contentr::ApplicationHelper
      include ParagraphsControllerExtension

      before_filter :find_page_or_content_block, only: [:new, :create, :index, :reorder]

      def index
        @paragraphs = @area_containing_element.paragraphs.order(:area_id, :asc).order(:position, :asc)
      end

      def new
        @area_name = params[:area_id]
        if params[:type].present?
          @paragraph = paragraph_type_class.new(area_name: @area_name)
          check_permission!(@paragraph)
          if params[:type] == 'Contentr::ContentBlock'
            @paragraph.content_block_id = params[:area_containing_element_id]
          else
            @paragraph.page_id = params[:area_containing_element_id]
          end
          render 'new', layout: false
        else
          render 'new_select'
        end
      end

      def create
        @paragraph = paragraph_type_class.new(paragraph_params)
        check_permission!(@paragraph)
        @paragraph.area_name = params[:area_id]
        if params[:type] == 'Contentr::ContentBlock'
          @paragraph.content_block_id = params[:area_containing_element_id]
        else
          @paragraph.page_id = params[:area_containing_element_id]
        end
        if @paragraph.save
          render partial: 'summary', locals: { paragraph: @paragraph.reload.for_edit }
        else
          @area_name = params[:area_id]
          render 'new', layout: false
        end
      end

      def edit
        @paragraph = Contentr::Paragraph.find_by(id: params[:id])
        check_permission!(@paragraph)
        @paragraph.for_edit
        if request.xhr?
          render action: 'edit', layout: false
        else
          render action: 'edit'
        end
      end

      def update
        @paragraph = Contentr::Paragraph.unscoped.find(params[:id])
        check_permission!(@paragraph)
        if paragraph_params.has_key?("remove_image")
          @paragraph.image_asset_wrapper_for(params[type.split('::').last.underscore.to_sym]["remove_image"]).remove_file!(@paragraph)
          params[type.split('::').last.underscore.to_sym].delete("remove_image")
        end
        if @paragraph.update(paragraph_params)
          @paragraph.reload
          @paragraph = @paragraph.for_edit
          @mode = params[:mode]
          render partial: 'summary', locals: { paragraph: @paragraph }
        else
          render action: 'edit', layout: false
        end
      end

      def show
        @paragraph = Contentr::Paragraph.find(params[:id])
        @paragraph.for_edit
        render partial: 'summary', locals: { paragraph: @paragraph }
      end

      def publish
        @paragraph = Contentr::Paragraph.find(params[:id])
        check_permission!(@paragraph)
        @paragraph.publish!
        render partial: 'summary', locals: { paragraph: @paragraph }
      end

      def revert
        @paragraph = Contentr::Paragraph.find(params[:id])
        check_permission!(@paragraph)
        @paragraph.revert!
        render partial: 'summary', locals: { paragraph: @paragraph }
      end

      def show_version
        @paragraph = Contentr::Paragraph.find(params[:id])
        check_permission!(@paragraph)
        @paragraph.for_edit if params[:version] == 'unpublished'
        render partial: "contentr/paragraphs/#{@paragraph.class.to_s.underscore}", locals: { paragraph: @paragraph }
      end

      def destroy
        paragraph = Contentr::Paragraph.find(params[:id])
        check_permission!(paragraph)
        paragraph.destroy
        render text: ''
      end

      def reorder
        paragraphs_ids = params[:paragraph_ids].split(',').map(&:to_i)
        @area_containing_element.paragraphs.where(area_name: params[:area_id]).each { |p| p.update_column(:position, paragraphs_ids.index(p.id)) }
        head :ok
      end

      def display
        paragraph = Contentr::Paragraph.find(params[:id])
        check_permission!(paragraph)
        paragraph.show!
        render partial: 'summary', locals: { paragraph: paragraph.for_edit }
      end

      def hide
        paragraph = Contentr::Paragraph.find(params[:id])
        check_permission!(paragraph)
        paragraph.hide!
        render partial: 'summary', locals: { paragraph: paragraph.for_edit }
      end

    protected

      def paragraph_type_class
        paragraph_type_string = params[:paragraph_type] # e.g. Contentr::HtmlParagraph
        paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
        paragraph_type_class if paragraph_type_class < Contentr::Paragraph
      end

      def find_page_or_content_block
        @area_containing_element = params[:type].constantize.find(params[:area_containing_element_id])
      end

      def paragraph_params
        type =  params['paragraph_type'] || Contentr::Paragraph.unscoped.find(params[:id]).class.name
        scope = type.split('::').last.underscore.to_sym
        return {} unless params[scope].present?
        params.require(scope).permit!
      end

      def check_permission!(paragraph)
        area_name = params[:area_id] || paragraph.try(:area_name)
        c = paragraph.is_a?(Class) ? paragraph : paragraph.class
        raise 'NO!' unless contentr_can_use_paragraph?(current_contentr_user, area_name, c)
      end
    end
  end
end
