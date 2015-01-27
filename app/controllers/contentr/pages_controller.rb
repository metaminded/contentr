class Contentr::PagesController < Contentr::ApplicationController
  include Contentr::PagesControllerExtension

  def index
    pages = Contentr::Page.where slug: params[:slug].split('_').last
    @area_containing_element = pages.find{ |p| p.url.downcase == request.path.downcase }
    if @area_containing_element.present? && (@area_containing_element.viewable?(preview_mode: in_preview_mode?) || contentr_authorized?(type: :manage, object: @area_containing_element))
      @area_containing_element.preview! if in_preview_mode?
      self.class.layout("layouts/#{Contentr.frontend_layout}")
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    find_page_for params
  end
end
