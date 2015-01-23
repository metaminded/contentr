class Contentr::PagesController < Contentr::ApplicationController
  def index
    pages = Contentr::Page.where slug: params[:slug].split('_').last
    @area_containing_element = pages.find{ |p| p.url.downcase == request.path.downcase }
    if @area_containing_element.present?
      self.class.layout("layouts/#{Contentr.frontend_layout}")
    else
      render text: 'Not Found', status: '404'
    end
  end

  def show
    find_page_for params
  end
end
