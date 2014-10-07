class ActionController::Base
  after_action :_contentr_confirm_access

  def find_page_for params, class_name: nil
    klass_name = params[:klass] || class_name || controller_name.classify
    self.instance_variable_set("@#{klass_name.downcase}", klass_name.constantize.find(params[:id]))
    obj = self.instance_variable_get("@#{klass_name.downcase}")
    if obj.default_page.present?
      if params[:slug].present?
        @contentr_page = obj.sub_pages.includes(:paragraphs).find_by(slug: params[:slug])
      else
        @contentr_page = obj.sub_pages.includes(:paragraphs).find_by(slug: params[:args])
      end
      @default_page = obj.default_page
    else
      @contentr_page = @default_page = nil
    end
    if @contentr_page.present? && (@contentr_page.viewable?(preview_mode: in_preview_mode?) || can?(:manage, @contentr_page))
      @page_to_display = @contentr_page.get_page_for_language(I18n.locale)
      if @page_to_display.present?
        if I18n.locale.to_s != @contentr_page.language
          flash.now[:notice] = I18n.t('contentr.content_not_available_in_language') if @contentr_page
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
    @contentr_page = @page_to_display = obj.generated_page_for_locale(I18n.locale)
    if @contentr_page.present?
      if I18n.locale.to_s != @contentr_page.language
        flash.now[:alert] = t('contentr.content_not_available_in_language')
      end
      if params[:preview] == 'true'
        @contentr_page.preview!
      end
      @default_page = @contentr_page
      self.class.layout(@contentr_page.layout)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def _contentr_confirm_access
    if @contentr_page.present? && @contentr_page.password?
      authenticate_or_request_with_http_basic do |u, p|
        p.strip == @contentr_page.password
      end
    end
  end
end
