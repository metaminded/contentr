# coding: utf-8

class MmCms::Admin::PagesController < MmCms::Admin::ApplicationController

  respond_to :html
  respond_to :json, :only => :update

  before_filter :setup

  def index

  end

  def edit
    @page = MmCms::Page.find(params[:id])
  end

  def update
    @page = MmCms::Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to :action => :edit
    else
      render :edit
    end
  end

  def reorder
    @page = MmCms::Page.find(params[:id])

    sibling_id = params[:sibling_id]
    @sibling = sibling_id ? MmCms::Page.find(sibling_id) : nil
    parent_id = params[:parent_id]
    @new_parent = parent_id ? MmCms::Page.find(parent_id) : nil

    @page.update_attributes(:parent => @new_parent)
    @sibling.present? ? @page.move_above(@sibling) : @page.move_to_bottom

    render :nothing => true, :status => 200
  end

  def navigation
    parent_id = params[:parent_id]
    @parent_page = parent_id.present? ? MmCms::Page.find(parent_id) : nil

    @pages = @parent_page.present? ? @parent_page.children.asc(:position) : MmCms::Page.roots.asc(:position)
  end

  protected

  def setup
    @mainmenu_id = 'pages'
  end

end