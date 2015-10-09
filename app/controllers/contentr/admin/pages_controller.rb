module Contentr
  module Admin
    class PagesController < Contentr::Admin::ApplicationController
      PERMITTED_PARAMS = [
        :name, :parent_id, :published, :language, :layout, :type,
        :displayable_type, :displayable_id, :slug, :page_type_id,
        :page_in_default_language_id, :password, :menu_id, :template
      ]

      before_action :load_root_page

      prepend PrependedPagesControllerExtension

      def index
        tabulatr_for Contentr::Page.where.not(type: ['Contentr::Site','Contentr::LinkedPage'])
      end

      def new
        @default_page = Contentr::Page.find(params[:default_page]) if params[:default_page].present?
        @page = Contentr::ContentPage.new(language: params[:language])
        @page.type = params[:page_type].constantize if (params[:page_type].present?)
        contentr_authorize!(type: :manage, object: @page)

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
        return render(:new) unless contentr_authorized?(type: :manage, object: @page)
        if @page.save
          if @page.type.nil?
            Contentr::NavPoint.create!(page: @page, title: @page.name, parent_page_id: @page.parent_id)
          end
          redirect_to contentr.edit_admin_page_path(@page), notice: t('.create_success')
        else
          render :new
        end
      end

      def edit
        @page = Contentr::Page.find(params[:id])
        contentr_authorize!(type: :manage, object: @page)
        @contentr_page = Contentr::Page.find(params[:id])
      end

      def update
        @page = Contentr::Page.find(params[:id])
        return render(:edit) unless contentr_authorized?(type: :manage, object: @page)
        if @page.update(page_params)
          redirect_to contentr.edit_admin_page_path(@page), notice: 'Seite wurde aktualisiert.'
        else
          render :action => :edit
        end
      end

      def destroy
        page = Contentr::Page.find(params[:id])
        contentr_authorize!(type: :manage, object: page)
        page.destroy
        redirect_to :back, notice: 'Seite wurde entfernt'
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
