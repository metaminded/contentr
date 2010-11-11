# coding: utf-8

class Cms::PagesController < Cms::ApplicationController

  def show
    path = params[:path]
    redirect_to cms_url(:path => '/index') if path.blank? # index should always exist

    @page = Cms::Item.find_by_path(path)
    @page.present? ? render_page : render_page_not_found
  end

protected

  def render_page
    render :text => "You are on page: #{@page.name} - #{@page.data.where(:name => 'foo').first}"
  end

  def render_page_not_found
    render :text => "No such page", :status => 404
  end

end