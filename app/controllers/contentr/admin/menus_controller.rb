class Contentr::Admin::MenusController < Contentr::Admin::ApplicationController
  def index
    authorize! :manage, Contentr::Menu.new
    tabulatr_for current_user.filter_by_context(Contentr::Menu.eager_load(:context_tags))
  end

  def new
    @contentr_menu = Contentr::Menu.new
    authorize! :manage, @contentr_menu
  end

  def create
    @contentr_menu = Contentr::Menu.new(menu_params)
    return render(:new) unless can?(:manage, @contentr_menu)
    if context_already_used?(@contentr_menu, menu_params[:context_tag_ids])
      flash[:notice] = 'Kontext wird bereits genutzt'
      return render(:new)
    end
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
    if context_already_used?(@contentr_menu, menu_params[:context_tag_ids])
      flash[:notice] = 'Kontext wird bereits genutzt'
      return render(:edit)
    end
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
      :name, :sid, context_tag_ids: [],
      nav_points_attributes: [:id, :title, :parent_id, :nav_point_type, :url, :page_id, :en_title, :visible, :_destroy]
    )
  end

  def context_already_used?(menu, ids)
    Contentr::Menu.joins(:context_tags).where(etikett_tags: { id: ids }).where.not(id: menu.id).count > 0
  end
end
