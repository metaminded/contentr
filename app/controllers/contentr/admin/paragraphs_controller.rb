# encoding: utf-8
class Contentr::Admin::ParagraphsController < Contentr::Admin::ApplicationController

  def new
    @page = Contentr::Page.find(params[:page_id])
    @paragraph = paragraph_type_class.new(:area_name => params[:area_name])
  end

  def create
    @page = Contentr::Page.find(params[:page_id])
    @paragraph = paragraph_type_class.new(params[:paragraph].merge(:area_name => params[:area_name]))
    @page.paragraphs << @paragraph
    if @page.save
      flash[:notice] = 'Paragraph created'
      redirect_to contentr_admin_new_paragraph_path(:page_id => @page, :area_name => params[:area_name], :type => 'Contentr::HtmlParagraph')
    else
      render :action => :new
    end
  end

  def edit
    @page = Contentr::Page.find(params[:page_id])
    @paragraph = @page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
  end

  def update
    @page = Contentr::Page.find(params[:page_id])
    @paragraph = @page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
    if @paragraph.update_attributes(params[:paragraph])
      flash[:notice] = 'Paragraph saved'
      redirect_to contentr_admin_edit_paragraph_path(:page_id => @page, :id => @paragraph)
    else
      render :action => :edit
    end
  end

  def destroy
    page = Contentr::Page.find(params[:page_id])
    paragraph = page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
    paragraph.destroy
    redirect_to :back
  end

  def reorder
    page = Contentr::Page.find(params[:page_id])
    paragraphs_ids = params[:paragraph]
    paragraphs = page.paragraphs_for_area(params[:area_name]).sort { |x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index { |p, i| p.update_attribute(:position, i) }

    render :nothing => true
  end

  protected

  def paragraph_type_class
    paragraph_type_string = params[:type] # e.g. Contentr::HtmlParagraph
    paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
    paragraph_type_class if paragraph_type_class < Contentr::Paragraph
  end

  #def reorder
  #  paragraph = Contentr::Paragraph.find(params[:id])
  #  buddyParagraph = Contentr::Paragraph.find(params[:buddy_id])
  #  paragraph.move_below(buddyParagraph)
  #  render :nothing => true
  #end

end