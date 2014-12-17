class Contentr::PagesController < Contentr::ApplicationController
  def index
    pages = Contentr::Page.where slug: params[:slug].split('_').last
    @contentr_page = pages.find{ |p| p.url.downcase == request.path.downcase }
    if @contentr_page.present?
      self.class.layout("layouts/#{Contentr.frontend_layout}")
    else
      render text: 'Not Found', status: '404'
    end
  end

  def show
    find_page_for params
  end
end
