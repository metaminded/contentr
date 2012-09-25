class Contentr::Admin::SitesController < Contentr::Admin::ApplicationController

  def new
    @site = Contentr::Site.new
  end

  def create
    @site = Contentr::Site.new(params[:site])
    @site.parent = nil

    if @site.save
      flash.now[:success] = 'Site created.'
      redirect_to contentr_admin_pages_path()
    else
      render :action => :new
    end
  end

end
