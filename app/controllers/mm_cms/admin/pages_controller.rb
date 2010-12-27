# coding: utf-8

class MmCms::Admin::PagesController < MmCms::Admin::ApplicationController

  respond_to :html
  respond_to :json, :only => :reorder

  before_filter :setup

  def index

  end

  def update

  end

  def reorder
    @page = MmCms::Page.find(params[:id])

    sibling_id = params[:sibling_id]
    @sibling = sibling_id ? MmCms::Page.find(sibling_id) : nil

    parent_id = params[:parent_id]
    @new_parent = parent_id ? MmCms::Page.find(parent_id) : nil

    @page.update_attributes(:parent => @new_parent)

    if @sibling.present?
      @page.move_above(@sibling)
    else
      @page.move_to_bottom
    end

    respond_with(@page)
  end

  protected

  def setup
    @mainmenu_id = 'pages'
  end

end