# coding: utf-8

class Contentr::PagesController < Contentr::ApplicationController

  # Global filters, setup, etc.
  before_filter :setup_locale, :setup_liquid

  def show
    path = params[:path]
    return redirect_to cms_url(:path => Contentr.default_page) if path.blank?

    @page = Contentr::Page.find_by_path(path)
    @page.present? ? render_page : render_page_not_found
  end

protected

  def setup_locale
    # If params[:locale] is nil then I18n.default_locale will be used
    # TODO: setting the locale should be persisted for the session
    I18n.locale = params[:locale]
  end

  def setup_liquid
    theme_name = Contentr.theme_name
    theme_name = params[:_theme] if params[:_theme].present?

    @liquid = Contentr::Liquid::RenderEngine.new(Contentr.themes_path, theme_name)
  end

  def render_page
    # Override layout by request if available
    layout = @page.layout
    layout = params[:_layout] if params[:_layout].present?

    render :text => @liquid.render_page(@page,
      :assigns   => {
        'request_params' => request.params,
        'page'           => @page,
        'theme_name'     => Contentr.theme_name
      },
      :registers => {
        'liquid'     => @liquid,
        'request'    => request,
        'page'       => @page,
        'theme_name' => Contentr.theme_name
      }
    )
  end

  def render_page_not_found
    # TODO: Implement me!
    render :text => "No such page", :status => 404
  end

end