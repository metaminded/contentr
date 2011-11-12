# encoding: utf-8
class Contentr::Admin::ParagraphsController < Contentr::Admin::ApplicationController

  def new
    @page = Contentr::ContentPage.find(params[:page_id])
    @area_name = params[:area_name]

    if params[:type].present?
      @paragraph = paragraph_type_class.new(:area_name => @area_name)
      render 'new'
    else
      render 'new_select'
    end
  end

  def create
    @page = Contentr::ContentPage.find(params[:page_id])
    @paragraph = paragraph_type_class.new(params[:paragraph].merge(:area_name => params[:area_name]))
    @page.paragraphs << @paragraph
    if @page.save
      flash[:notice] = 'Paragraph created'
      redirect_to contentr_admin_new_paragraph_path(:page_id => @page, :area_name => params[:area_name])
    else
      render :action => :new
    end
  end

  def edit
    @page = Contentr::ContentPage.find(params[:page_id])
    @paragraph = @page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
  end

  def update
    @page = Contentr::ContentPage.find(params[:page_id])
    @paragraph = @page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
    if @paragraph.update_attributes(params[:paragraph])
      flash[:notice] = 'Paragraph saved'
      redirect_to contentr_admin_edit_paragraph_path(:page_id => @page, :id => @paragraph)
    else
      render :action => :edit
    end
  end

  def destroy
    page = Contentr::ContentPage.find(params[:page_id])
    paragraph = page.paragraphs.select { |p| p.id.to_s == params[:id] }.first
    paragraph.destroy
    redirect_to :back
  end

  def reorder
    page = Contentr::ContentPage.find(params[:page_id])
    paragraphs_ids = params[:paragraph]
    paragraphs = page.paragraphs_for_area(params[:area_name]).sort { |x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index { |p, i| p.update_attribute(:position, i) }
    puts "mooo"
    #render nothing: true, layout: nil
    head :ok
    puts "foo"
  end

  protected

  def paragraph_type_class
    paragraph_type_string = params[:type] # e.g. Contentr::HtmlParagraph
    paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
    paragraph_type_class if paragraph_type_class < Contentr::Paragraph
  end

end
