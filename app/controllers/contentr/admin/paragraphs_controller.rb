# encoding: utf-8
class Contentr::Admin::ParagraphsController < Contentr::Admin::ApplicationController
  include Contentr::ApplicationHelper
  include ParagraphsControllerExtension

  before_filter :find_page_or_site

  def index
    @paragraphs = @page.paragraphs.order_by(:area_id, :asc).order_by(:position, :asc)
  end

  def new
    @area_name = params[:area_id]
    if params[:type].present?
      @paragraph = paragraph_type_class.new(area_name: @area_name)
      check_permission!(@paragraph)
      if !params[:content_block_id].present?
        @paragraph.page_id = params[:page_id]
      else
        @paragraph.content_block_id = params[:content_block_id]
      end
      render 'new', layout: false
    else
      render 'new_select'
    end
  end

  def create
    @paragraph = paragraph_type_class.new(paragraph_params)
    check_permission!(@paragraph)
    @paragraph.area_name = params[:area_id]
    if !params[:content_block_id].present?
      @paragraph.page_id = params[:page_id]
    else
      @paragraph.content_block_id = params[:content_block_id]
    end
    if @paragraph.save
      render partial: 'summary', locals: { paragraph: @paragraph.reload.for_edit, page: @page }
    else
      render text: "Fehler :("
    end
  end

  def edit
    @paragraph = Contentr::Paragraph.find_by(id: params[:id])
    check_permission!(@paragraph)
    @paragraph.for_edit
    if request.xhr?
      render action: 'edit', layout: false
    else
      render action: 'edit'
    end
  end

  def update
    @paragraph = Contentr::Paragraph.unscoped.find(params[:id])
    check_permission!(@paragraph)
    if paragraph_params.has_key?("remove_image")
      @paragraph.image_asset_wrapper_for(params[type.split('::').last.underscore.to_sym]["remove_image"]).remove_file!(@paragraph)
      params[type.split('::').last.underscore.to_sym].delete("remove_image")
    end
    if @paragraph.update(paragraph_params)
      @paragraph.reload
      @paragraph = @paragraph.for_edit
      @mode = params[:mode]
      render partial: 'summary', locals: { paragraph: @paragraph, page: @page }
    else
      render text: "Problem! #{@paragraph.errors.full_messages}"
    end
  end

  def show
    @paragraph = @page_or_site.paragraphs.find(params[:id])
    @paragraph.for_edit
    render partial: 'summary', locals: { paragraph: @paragraph, page: @page }
  end

  def publish
    @paragraph = Contentr::Paragraph.find(params[:id])
    check_permission!(@paragraph)
    @paragraph.publish!
    render partial: 'summary', locals: { paragraph: @paragraph, page: @page }
  end

  def revert
    @paragraph = Contentr::Paragraph.find(params[:id])
    check_permission!(@paragraph)
    @paragraph.revert!
    render partial: 'summary', locals: { paragraph: @paragraph, page: @page }
  end

  def show_version
    raise ActiveRecord::RecordNotFound.new('Not Found') if @page.nil?
    if params[:id] == 'all'
      pp = @page.paragraphs_for_area(params[:area_id])
      h = Hash[pp.map do |paragraph|
        paragraph.for_edit if params[:version] == 'unpublished'
        s = render_to_string partial: "contentr/paragraphs/#{paragraph.class.to_s.underscore}", locals: { paragraph: paragraph }
        [paragraph.id, s]
      end]
      render json: h
    else
      @paragraph = Contentr::Paragraph.find(params[:id])
      check_permission!(@paragraph)
      @paragraph.for_edit if params[:version] == 'unpublished'
      render partial: "contentr/paragraphs/#{@paragraph.class.to_s.underscore}", locals: { paragraph: @paragraph }
    end
  end

  def destroy
    paragraph = Contentr::Paragraph.find(params[:id])
    check_permission!(paragraph)
    paragraph.destroy
    render text: ''
    # redirect_to :back, notice: t('.message')
  end

  def reorder
    paragraphs_ids = params[:paragraph_ids].split(',')
    paragraphs = @page_or_site.paragraphs_for_area(params[:area_id]).sort{|x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index { |p, i| p.update_column(:position, i) }
    head :ok
  end

  def display
    paragraph = Contentr::Paragraph.find(params[:id])
    check_permission!(paragraph)
    paragraph.show!
    render partial: 'summary', locals: { paragraph: paragraph.for_edit, page: @page }
  end

  def hide
    paragraph = Contentr::Paragraph.find(params[:id])
    check_permission!(paragraph)
    paragraph.hide!
    render partial: 'summary', locals: { paragraph: paragraph.for_edit, page: @page }
  end

protected

  def paragraph_type_class
    paragraph_type_string = params[:type] # e.g. Contentr::HtmlParagraph
    paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
    paragraph_type_class if paragraph_type_class < Contentr::Paragraph
  end

  def find_page_or_site
    if (params[:site] == 'true')
      @page_or_site = Contentr::Site.default
      @page = Contentr::Page.find(params[:page_id])
    elsif params[:content_block_id].present?
      @page_or_site = Contentr::ContentBlock.find_by(id: params[:content_block_id])
      @page = @page_or_site
    else
      @page_or_site = Contentr::Page.find_by(id: params[:page_id])
      @page = @page_or_site
    end
  end

  def paragraph_params
    type =  params['type'] || Contentr::Paragraph.unscoped.find(params[:id]).class.name
    scope = type.split('::').last.underscore.to_sym
    return {} unless params[scope].present?
    params.require(scope).permit!
  end

  def check_permission!(paragraph)
    c = paragraph.is_a?(Class) ? paragraph : paragraph.class
    raise 'NO!' unless contentr_can_use_paragraph?(current_user, params[:area_id], c)
  end
end
