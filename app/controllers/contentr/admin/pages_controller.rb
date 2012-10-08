class Contentr::Admin::PagesController < Contentr::Admin::ApplicationController

  before_filter :load_root_page

  def index
    @pages = @root_page.present? ? @root_page.children
                                 : Contentr::Site.roots
    @page = @root_page.present? ? @root_page : nil
    # @contentr_page = @root_page.present? ? @root_page : Contentr::Site.default
    @contentr_page = @root_page.present? ? @root_page : nil
  end

  def new
    @page = Contentr::ContentPage.new
  end

  def create
    @page = Contentr::ContentPage.new(params[:page])
    if @root_page.present?
      @page.parent = @root_page
    else
      @page.parent = Contentr::Site.default
    end

    if @page.save
      flash[:success] = 'Page created.'
      redirect_to contentr_admin_pages_path(:root => @root_page)
    else
      render :action => :new
    end
  end

  def edit
    @page = Contentr::Page.find(params[:id])
    @contentr_page = Contentr::Page.find(params[:id])
  end

  def update
    @page = Contentr::Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:success] = 'Page updated.'
      redirect_to contentr_admin_pages_path(:root => @page.root)
    else
      render :action => :edit
    end
  end

  def destroy
    page = Contentr::ContentPage.find(params[:id])
    page.destroy
    redirect_to contentr_admin_pages_path(:root => @root_page)
  end

  private

  def load_root_page
    @root_page = Contentr::Page.find(params[:root]) if params[:root].present?
  end

end
