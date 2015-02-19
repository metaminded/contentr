class Contentr::Admin::NavPointsController < Contentr::Admin::ApplicationController

  def index
    @nav_tree = Contentr::NavPoint.navigation_tree
  end

  def new
    @nav_point = Contentr::NavPoint.new(parent_id: params[:parent])
  end

  def create
    @nav_point = Contentr::NavPoint.new(nav_point_params)
    if @nav_point.save
      redirect_to contentr.admin_nav_points_path, notice: t('.success')
    else
      render action: 'new', alert: t('.failure')
    end
  end

  def edit
    @nav_point = Contentr::NavPoint.eager_load(:page).find(params[:id])
    @page = @nav_point.page
  end

  def update
    @nav_point = Contentr::NavPoint.find(params[:id])
    if @nav_point.update(nav_point_params)
      redirect_to(:back, notice: t('.success'))
    else
      render({action: :edit}, alert: t('.failure'))
    end
  end

  def destroy
    @nav_point = Contentr::NavPoint.find(params[:id])
    @nav_point.destroy
    redirect_to(:back, notice: t('.success'))
  end

  def reorder
    nav_points = params[:ids].split(',').map{|id| Contentr::NavPoint.find(id)}
    nav_points.each.with_index do |np, i|
      if np.id == params[:item].to_i
        np.parent_id = params[:parent]
      end
      np.position = i
      np.save! if np.changed?
    end
    render nothing: true
  end
  private

  def nav_point_params
    params.require(:nav_point).permit(:title, :parent_id, :url, :page_id, :en_title, :en_url, :visible, alternative_links_attributes: [:id, :page_id, :language])
  end
end
