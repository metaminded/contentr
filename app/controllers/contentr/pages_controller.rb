class Contentr::PagesController < Contentr::ApplicationController
  def index
    params[:slug] = params[:slug].split('_').last
    @contentr_page = Contentr::Page.find_by slug: params[:slug]
    if @contentr_page.present?
      self.class.layout("layouts/frontend/application")
    else
      render text: 'Not Found', status: '404'
    end
  end

  def show
    find_page_for params
  end
end
