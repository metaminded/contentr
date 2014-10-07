class Contentr::Admin::SubPagesController < Contentr::Admin::ApplicationController
  layout 'application'
  def index
    @parent_page = Contentr::Page.find(params[:id])
    @sub_nav_items =  @parent_page.sub_nav_items.order('position asc')
  end

  def reorder
    nav_point_ids = params[:navpoints]
    if nav_point_ids.present?
      non_removable_nav_points = Contentr::NavPoint.where(removable: false, parent_page_id: params[:id]).count
      nav_points = Contentr::NavPoint.where(parent_page_id: params[:id], removable: true).sort { |x,y| nav_point_ids.index(x.id.to_s) <=> nav_point_ids.index(y.id.to_s) }
      nav_points.each_with_index { |p, i| p.update_column(:position, i + non_removable_nav_points) }
    end
    head :ok
  end
end
