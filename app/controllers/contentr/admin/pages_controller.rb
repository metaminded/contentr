class Contentr::Admin::PagesController < Contentr::Admin::ApplicationController

  before_filter :load_root_page

  def index
    @pages = @root_page.present? ? @root_page.children.asc(:position)
                                 : Contentr::Page.roots.asc(:position)
  end

  def new
    @page = Contentr::Page.new
  end

  def create
    @page = Contentr::Page.new(params[:page])
    @page.parent = @root_page if @root_page.present?
    if @page.save
      flash[:success] = 'Page created.'
      redirect_to contentr_admin_pages_path(:root => @root_page)
    else
      render :action => :new
    end
  end

  def edit
    @page = Contentr::Page.find(params[:id])
  end

  def update
    @page = Contentr::Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:success] = 'Page updated.'
      redirect_to contentr_admin_pages_path(:root => @root_page)
    else
      render :action => :edit
    end
  end

  def destroy
    page = Contentr::Page.find(params[:id])
    page.destroy
    redirect_to contentr_admin_pages_path(:root => @root_page)
  end

  def move_below
    page = Contentr::Page.find(params[:id])
    buddy_page = Contentr::Page.find(params[:buddy_id])
    page.move_below(buddy_page)
    render :nothing => true
  end

  def insert_into
    page = Contentr::Page.find(params[:id])
    if (params[:root_page_id])
      page.parent = Contentr::Page.find(params[:root_page_id])
    else
      page.parent = nil
    end
    page.reload
    page.move_to_top
    render :nothing => true
  end

  private

  def load_root_page
    @root_page = Contentr::Page.find(params[:root]) if params[:root].present?
  end

end