# coding: utf-8

class MmCms::PagesController < MmCms::ApplicationController

  # Global filters, setup, etc.
  before_filter :setup_site, :setup_locale, :setup_liquid

  def show
    path = params[:path]
    return redirect_to cms_url(:path => @site.default_page_path) if path.blank?

    @page = MmCms::Page.find_by_path(path)
    @page.present? ? render_page : render_page_not_found
  end

protected

  def setup_site
    @site = MmCms::Site.new # Site is a singleton. FIXME!!
  end

  def setup_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  def setup_liquid
    @liquid = MmCms::Liquid::RenderEngine.new(@site.themes_path, @site.theme_name, request)
  end

  def render_page
    render :text => @liquid.render_template(@page.layout, @page.template,
      :assigns   => {
        'request_params' => request.params,
        'page'           => @page,
        'site'           => @site
      },
      :registers => {
        'controller' => self,
        'request'    => request,
        'page'       => @page,
        'site'       => @site
      }
    )
  end

  def render_page_not_found
    render :text => "No such page", :status => 404
  end

end