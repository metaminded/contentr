module Contentr
  module Admin
    class MenusController < Contentr::Admin::ApplicationController
      PERMITTED_PARAMS = [
        :name, :sid,
        nav_points_attributes: [:id, :title, :parent_id, :nav_point_type, :url, :page_id, :en_title, :visible, :open_in_new_tab, :_destroy, :en_url, alternative_links_attributes: [:id, :page_id, :language]]
      ]

      prepend PrependedMenusControllerExtension

      def index
        contentr_authorize!(type: :manage, object: Contentr::Menu.new)
        tabulatr_for Contentr::Menu
      end

      def new
        @contentr_menu = Contentr::Menu.new
        contentr_authorize!(type: :manage, object: @contentr_menu)
      end

      def create
        @contentr_menu = Contentr::Menu.new(menu_params)
        return render(:new) unless contentr_authorized?(type: :manage, object: @contentr_menu)
        if @contentr_menu.save!
          flash[:notice] = t('.create_success')
          redirect_to contentr.admin_menus_path
        else
          flash[:alert] = t('.create_problem')
          render :new
        end
      end

      def edit
        @contentr_menu = Contentr::Menu.includes(nav_points: :page).find(params[:id])
        contentr_authorize!(type: :manage, object: @contentr_menu)
      end

      def update
        @contentr_menu = Contentr::Menu.find(params[:id])
        return render(:edit) unless contentr_authorized?(type: :manage, object: @contentr_menu)
        if @contentr_menu.update(menu_params)
          flash[:notice] = t('.update_success')
          redirect_to contentr.admin_menus_path
        else
          flash[:alert] = t('.update_problem')
          render :edit
        end
      end

      def destroy
        @contentr_menu = Contentr::Menu.find(params[:id])
        return render(:index) unless contentr_authorized?(type: :manage, object: @contentr_menu)
        if @contentr_menu.destroy
          redirect_to contentr.admin_menus_path, notice: t('.destroy_success')
        else
          redirect_to contentr.admin_menus_path, alert: t('.destroy_problem')
        end
      end

      private

      def menu_params
        params.require(:menu).permit(
          PERMITTED_PARAMS
        )
      end
    end
  end
end
