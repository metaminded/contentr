# coding: utf-8

class MmCms::Admin::PagesController < MmCms::Admin::ApplicationController

  before_filter :setup

  def index

  end

  protected

  def setup
    @mainmenu_id = 'pages'
  end

end