class Contentr::PagesController < Contentr::ApplicationController
  include Contentr::PagesControllerExtension

  def index
    @area_containing_element = find_page
    if @area_containing_element.present? && (@area_containing_element.viewable?(preview_mode: in_preview_mode?) || contentr_authorized?(type: :manage, object: @area_containing_element))
      @area_containing_element = @area_containing_element.get_page_for_language(I18n.locale)
      @area_containing_element.preview! if in_preview_mode?
      flash.now[:notice] = t('contentr.content_not_available_in_language') if @area_containing_element.language != I18n.locale.to_s
      tmpl = @area_containing_element.try(:template).presence || action_name
      render_page(action: tmpl, layout: "layouts/#{frontend_layout}")
    else
      raise ActiveRecord::RecordNotFound, "Contentr::Page not found: `#{params[:slug]}'"
    end
  end

  private def find_page
    current_locale = params[:locale].presence || I18n.default_locale.to_s
    possible_pages = Contentr::ContentPage.where(slug: params[:slug].split('_').last, language: current_locale).to_a
    if possible_pages.empty? && current_locale != I18n.default_locale.to_s
      possible_pages = Contentr::ContentPage.where(slug: params[:slug].split('_').last, language: I18n.default_locale.to_s).to_a
    end
    possible_pages.find{|pp| pp.url_slug == params[:slug]}
  end

  private def frontend_layout
    Contentr.frontend_layout
  end

  def show
    find_page_for params
  end
end
