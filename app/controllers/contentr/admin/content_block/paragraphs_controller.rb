class Contentr::Admin::ContentBlock::ParagraphsController < Contentr::Admin::ApplicationController
  layout 'application'

  def new
    paragraph_class = paragraph_type_class
    if paragraph_class
      @paragraph = paragraph_class.new
      @content_block = Contentr::ContentBlock.find(params[:content_block_id])
      render 'new', layout: false
    else
      raise 'Invalid Paragraph class'
    end
  end

  def create
    @paragraph = paragraph_type_class.new(paragraph_params)
    @content_block = Contentr::ContentBlock.find(params[:content_block_id])
    @content_block.paragraphs << @paragraph
    if @content_block.save!
      if request.xhr?
        @paragraph = @paragraph.for_edit
        render action: 'show', layout: false
      else
        redirect_to contentr.edit_admin_content_block_path(@content_block), 'Paragraph created'
      end
    else
      render :action => :new
    end
  end

  def index
    @content_block = Contentr::ContentBlock.find(params[:content_block_id])
    if @content_block.partial.present?
      redirect_to :back, 'Paragraphen können nur benutzt werden, wenn kein Partial gesetzt ist'
    else
      @paragraphs = @content_block.paragraphs
    end
  end

  def reorder
    paragraphs_ids = params[:paragraph]
    paragraphs = Contentr::ContentBlock.find(params[:content_block_id]).paragraphs.sort { |x,y| paragraphs_ids.index(x.id.to_s) <=> paragraphs_ids.index(y.id.to_s) }
    paragraphs.each_with_index { |p, i| p.update_column(:position, i) }
    head :ok
  end

  private

  def paragraph_type_class
    paragraph_type_string = params[:type] # e.g. Contentr::HtmlParagraph
    paragraph_type_class = paragraph_type_string.classify.constantize # just to be sure
    paragraph_type_class if paragraph_type_class < Contentr::Paragraph
  end

  def paragraph_params
    type = params['type']
    params.require(type.constantize.model_name.param_key.to_sym).permit(*(type.constantize.permitted_attributes + [:content_block_id]))
  end
end
