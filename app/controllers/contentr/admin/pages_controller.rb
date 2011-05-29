class Contentr::Admin::PagesController < Contentr::Admin::ApplicationController

  def index
  end

  def new
    @page = Contentr::Page.new
  end

  def create
    @page = Contentr::Page.new(params[:contentr_page])
    if @page.save
      flash[:success] = 'Page created.'
      redirect_to :action => :index
    else
      flash[:error] = 'Page could not created.'
      render :action => :new
    end
  end

  def destroy
    page = Contentr::Page.find(params[:id])
    page.destroy
    redirect_to :action => :index
  end

end