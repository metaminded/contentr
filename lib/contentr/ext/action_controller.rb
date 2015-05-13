class ActionController::Base
  after_action :_contentr_confirm_access

  def find_page_for params, class_name: nil
    klass_name = params[:klass] || class_name || controller_name.classify
    self.instance_variable_set("@#{klass_name.downcase}", klass_name.constantize.find(params[:id]))
    obj = self.instance_variable_get("@#{klass_name.downcase}")
    if obj.default_page.present?
      if params[:slug].present?
        @area_containing_element = obj.sub_pages.includes(:paragraphs).find_by(slug: params[:slug])
      else
        @area_containing_element = obj.sub_pages.includes(:paragraphs).find_by(slug: params[:args])
      end
      @default_page = obj.default_page
    else
      @area_containing_element = @default_page = nil
    end
    if @area_containing_element.present? && (@area_containing_element.viewable?(preview_mode: in_preview_mode?) || contentr_authorized?(type: :manage, object: @area_containing_element))
      @page_to_display = @area_containing_element.get_page_for_language(I18n.locale)
      if @page_to_display.present?
        if I18n.locale.to_s != @area_containing_element.language
          flash.now[:notice] = I18n.t('contentr.content_not_available_in_language') if @area_containing_element.paragraphs.any?
        end
        @page_to_display.preview! if in_preview_mode?
        self.class.layout("layouts/#{@page_to_display.layout}")
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def in_preview_mode?
    params['preview'] == 'true'
  end

  def find_page_for_object obj, params
    @area_containing_element = @page_to_display = obj.generated_page_for_locale(I18n.locale)
    if @area_containing_element.present?
      if I18n.locale.to_s != @area_containing_element.language
        flash.now[:alert] = t('contentr.content_not_available_in_language') if @area_containing_element.paragraphs.any?
      end
      if params[:preview] == 'true'
        @area_containing_element.preview!
      end
      @default_page = @area_containing_element
      self.class.layout(@area_containing_element.layout)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def _contentr_confirm_access
    if @area_containing_element.present? && @area_containing_element.password?
      authenticate_or_request_with_http_basic do |u, p|
        p.strip == @area_containing_element.password
      end
    end
  end

  protected

  def render_page(action: nil, layout: nil)
    render action, layout: layout
  end
end
