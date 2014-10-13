class Contentr::Admin::MenusController < Contentr::Admin::ApplicationController
  PERMITTED_PARAMS = [
    :name, :sid,
    nav_points_attributes: [:id, :title, :parent_id, :nav_point_type, :url, :page_id, :en_title, :visible, :_destroy]
  ]

  prepend PrependedMenusControllerExtension

  def index
    authorize! :manage, Contentr::Menu.new
    tabulatr_for Contentr::Menu
  end

  def new
    @contentr_menu = Contentr::Menu.new
    authorize! :manage, @contentr_menu
  end

  def create
    @contentr_menu = Contentr::Menu.new(menu_params)
    return render(:new) unless can?(:manage, @contentr_menu)
    if @contentr_menu.save
      flash[:notice] = t('.create_success')
      redirect_to contentr.admin_menus_path
    else
      flash[:notice] = t('.create_problem')
      render :new
    end
  end

  def edit
    @contentr_menu = Contentr::Menu.includes(nav_points: :page).find(params[:id])
    authorize! :manage, @contentr_menu
  end

  def update
    @contentr_menu = Contentr::Menu.find(params[:id])
    return render(:edit) unless can?(:manage, @contentr_menu)
    if @contentr_menu.update(menu_params)
      flash[:notice] = t('.update_success')
      redirect_to contentr.admin_menus_path
    else
      flash[:notice] = t('.update_problem')
      render :edit
    end
  end

  private

  def menu_params
    params.require(:menu).permit(
      PERMITTED_PARAMS
    )
  end
end
