# coding: utf-8

class Contentr::PagesController < Contentr::ApplicationController

  # Global filters, setup, etc.
  before_filter :setup_locale, :setup_render_engine

  def show
    path = params[:path]
    return redirect_to contentr_url(:path => Contentr.default_page) if path.blank?

    @page = Contentr::Page.find_by_path(path)
    @page.present? ? render_page : render_page_not_found
  end

protected

  def setup_locale
    # If params[:locale] is nil then I18n.default_locale will be used
    # TODO: setting the locale should be persisted for the session
    I18n.locale = params[:locale]
  end

  def setup_render_engine
    @render_engine = Contentr::RenderEngine.new
  end

  def render_page
    # Override layout by request if available
    layout = @page.layout
    layout = params[:_layout] if params[:_layout].present?

    render :text => @render_engine.render_page(@page, request, self)
  end

  def render_page_not_found
    # TODO: Implement me!
    render :text => "No such page", :status => 404
  end

end