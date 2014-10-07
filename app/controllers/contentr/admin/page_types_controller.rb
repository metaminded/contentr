class Contentr::Admin::PageTypesController < Contentr::Admin::ApplicationController

  def index
    tabulatr_for Contentr::PageType
  end

  def new
    @page_type = Contentr::PageType.new
  end

  def create
    @page_type = Contentr::PageType.new(page_type_params)
    if @page_type.save!
      redirect_to contentr.admin_page_types_path, notice: 'PageType was created.'
    else
      render :action => :new
    end
  end

  def show
  end

  def edit
    @page_type = Contentr::PageType.find(params[:id])
  end

  def update
    @page_type = Contentr::PageType.find(params[:id])
    if @page_type.update(page_type_params)
      redirect_to contentr.admin_page_types_path
    else
      render :action => :edit
    end
  end

  def destroy
    @page_type = Contentr::PageType.find(params[:id])
    @page_type.destroy
    redirect_to contentr.page_types_path, notice: 'PageType was destroyed'
  end

  private

  def page_type_params
    params.require(:page_type).permit(:name, :header_offset, :col1_offset,
      :col2_offset, :col3_offset, :col1_width, :col2_width, :col3_width,
      :header_allowed_paragraphs, :col1_allowed_paragraphs, :col2_allowed_paragraphs,
      :col3_allowed_paragraphs)
  end
end
