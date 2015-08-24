class Contentr::Admin::ContentBlock::ParagraphsController < Contentr::Admin::ApplicationController

  def new
    paragraph_class = paragraph_type_class
    if paragraph_class
      @paragraph = paragraph_class.new
      @area_containing_element = Contentr::ContentBlock.find(params[:content_block_id])
      @area_name = params[:area_id]
      render  'contentr/admin/paragraphs/new', layout: false
    else
      raise 'Invalid Paragraph class'
    end
  end

  def create
    @paragraph = paragraph_type_class.new(paragraph_params)
    @paragraph.area_name = params[:area_id]
    @content_block = Contentr::ContentBlock.find(params[:content_block_id])
    @content_block.paragraphs << @paragraph
    if @content_block.save
      if request.xhr?
        @paragraph = @paragraph.for_edit
        render partial: 'summary', locals: { paragraph: @paragraph.reload.for_edit, page: @page }
      else
        redirect_to contentr.edit_admin_content_block_path(@content_block), 'Paragraph created'
      end
    else
      render :action => :new
    end
  end

  def index
    @area_containing_element = Contentr::ContentBlock.find(params[:content_block_id])
    if @area_containing_element.partial.present?
      redirect_to :back, 'Paragraphen können nur benutzt werden, wenn kein Partial gesetzt ist'
    else
      @paragraphs = @area_containing_element.paragraphs
    end
  end

  def reorder
    paragraphs_ids = params[:paragraph]
    paragraphs = Contentr::ContentBlock.find(params[:content_block_id]).paragraphs.sort { |x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index do |p, i|
      p.skip_callbacks = true
      p.update(position: i)
    end
    head :ok
  end

  private

  def paragraph_type_class
    paragraph_type_string = params[:type] # e.g. Contentr::HtmlParagraph
    paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
    paragraph_type_class if paragraph_type_class < Contentr::Paragraph
  end

  def paragraph_params
    type =  params['type'] || Contentr::Paragraph.unscoped.find(params[:id]).class.name
    scope = type.split('::').last.underscore.to_sym
    return {} unless params[scope].present?
    params.require(scope).permit!
  end
end
