class Contentr::Admin::PagesController < Contentr::Admin::ApplicationController

  before_filter :load_root_page

  def index
    @pages = @root_page.present? ? @root_page.children
                                 : Contentr::Site.find_by_name(Contentr.default_site).children
  end

  def new
    @page = Contentr::ContentPage.new
  end

  def create
    @page = Contentr::ContentPage.new(params[:page])
    if @root_page.present?
      @page.parent = @root_page
    else
      @page.parent = Contentr::Site.find_by_name(Contentr.default_site)
    end

    if @page.save
      flash[:success] = 'Page created.'
      redirect_to contentr_admin_pages_path(:root => @root_page)
    else
      render :action => :new
    end
  end

  def edit
    @page = Contentr::ContentPage.find(params[:id])
  end

  def update
    @page = Contentr::ContentPage.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:success] = 'Page updated.'
      redirect_to contentr_admin_pages_path(:root => @root_page)
    else
      render :action => :edit
    end
  end

  def destroy
    page = Contentr::ContentPage.find(params[:id])
    page.destroy
    redirect_to contentr_admin_pages_path(:root => @root_page)
  end

  def move_below
    page = Contentr::ContentPage.find(params[:id])
    buddy_page = Contentr::ContentPage.find(params[:buddy_id])
    page.move_below(buddy_page)
    render :nothing => true
  end

  def insert_into
    page = Contentr::ContentPage.find(params[:id])
    if (params[:root_page_id])
      page.parent = Contentr::ContentPage.find(params[:root_page_id])
    else
      page.parent = nil
    end
    page.reload
    page.move_to_top
    render :nothing => true
  end

  private

  def load_root_page
    @root_page = Contentr::ContentPage.find(params[:root]) if params[:root].present?
  end

end