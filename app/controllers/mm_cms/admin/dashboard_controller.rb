# coding: utf-8

class MmCms::Admin::DashboardController < MmCms::Admin::ApplicationController

  before_filter :setup

  def index

  end

  protected

  def setup
    @mainmenu_id = 'dashboard'
  end

end