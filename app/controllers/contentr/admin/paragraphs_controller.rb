# encoding: utf-8
class Contentr::Admin::ParagraphsController < Contentr::Admin::ApplicationController

  def index
    raise "no"
  end

  def new
    @paragraph = Contentr::Paragraph.new
  end

  def edit
    @page = Contentr::Page.find(params[:page_id])
    @paragraph = @page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
  end

  def update
    @page = Contentr::Page.find(params[:page_id])
    @paragraph = @page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
    if @paragraph.update_attributes(params[:paragraph])
      flash[:notice] = 'Erfolgreich geändert'
      redirect_to edit_contentr_admin_page_paragraph_path(@page, @paragraph)
    else
      render :action => :edit
    end
  end

  def create
    @paragraph = Contentr::Paragraph.new(params[:contentr_paragraph])
    if @paragraph.save
      flash[:success] = 'Paragraph created.'
      redirect_to :action => :index
    else
      flash[:error] = 'Paragraph could not created.'
      render :action => :new
    end
  end

  def destroy
    paragraph = Contentr::Paragraph.find(params[:id])
    paragraph.destroy
    redirect_to :action => :index
  end

  def reorder
    paragraph = Contentr::Paragraph.find(params[:id])
    buddyParagraph = Contentr::Paragraph.find(params[:buddy_id])
    paragraph.move_below(buddyParagraph)
    render :nothing => true
  end

end