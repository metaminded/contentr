class Contentr::Admin::GroupedNavPointsController < Contentr::Admin::ApplicationController
  layout 'application'

  def new
    @grouped_nav_point = Contentr::GroupedNavPoint.new(parent_id: params[:parent])
  end

  def create
    @nav_point = Contentr::GroupedNavPoint.new(grouped_nav_point_params)
    if @nav_point.save
      redirect_to contentr.admin_nav_points_path
    else
      render action: 'new', notice: 'save failed'
    end
  end

  private

  def grouped_nav_point_params
    params.require(:grouped_nav_point).permit(:title, :parent_id)
  end
end
