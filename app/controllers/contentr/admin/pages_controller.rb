module Contentr
  module Admin
    class PagesController < ApplicationController
      PERMITTED_PARAMS = [
        :name, :parent_id, :published, :language, :layout, :type,
        :displayable_type, :displayable_id, :slug, :page_type_id,
        :page_in_default_language_id, :password, :menu_id
      ]

      before_action :load_root_page

      layout 'application'

      prepend PrependedPagesControllerExtension

      def index
        tabulatr_for Contentr::Page.where.not(type: 'Contentr::LinkedPage')
      end

      def new
        @default_page = Contentr::Page.find(params[:default_page]) if params[:default_page].present?
        @page = Contentr::ContentPage.new(language: params[:language])
        @page.type = params[:page_type].constantize if (params[:page_type].present?)
        authorize!(:manage, @page)

        if @default_page.present?
          @page.page_in_default_language = @default_page
          @page.displayable = @default_page.displayable
          @page.parent = @default_page.parent
          @page.page_type = @default_page.page_type
          @page.layout = @default_page.layout
        end
      end

      def create
        @page = Contentr::Page.new(page_params)
        return render(:new) unless can?(:manage, @page)
        ActiveRecord::Base.transaction do
          begin
            @page.save!
            Contentr::NavPoint.create!(page: @page, title: @page.name, parent_page_id: @page.parent_id, visible: false)
          rescue ActiveRecord::RecordInvalid
            redirect_to :back, notice: @page.errors.full_messages.join
            return
          end
          return redirect_to contentr.edit_admin_page_path(@page), notice: 'Seite wurde erstellt.'
        end
      end

      def edit
        @page = Contentr::Page.find(params[:id])
        authorize!(:manage, @page)
        @contentr_page = Contentr::Page.find(params[:id])
      end

      def update
        @page = Contentr::Page.find(params[:id])
        return render(:edit) unless can?(:manage, @page)
        if @page.update(page_params)
          redirect_to contentr.edit_admin_page_path(@page), notice: 'Seite wurde aktualisiert.'
        else
          render :action => :edit
        end
      end

      def destroy
        page = Contentr::Page.find(params[:id])
        authorize!(:manage, page)
        page.destroy
        redirect_to :back, notice: 'Seite wurde entfernt'
      end

      def publish
        page = Contentr::Page.find(params[:id])
        page.publish!
        redirect_to :back, notice: 'Seite wurde veröffentlicht'
      end

      def hide
        page = Contentr::Page.find(params[:id])
        page.hide!
        redirect_to :back, notice: 'Seite ist jetzt verborgen'
      end

      private

      def load_root_page
        @root_page = Contentr::Page.find(params[:root]) if params[:root].present?
      end

      protected

      def page_params
        params.require(:page).permit(
          PERMITTED_PARAMS
        )
      end
    end
  end
end
