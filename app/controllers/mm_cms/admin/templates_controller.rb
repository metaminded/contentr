# coding: utf-8

class MmCms::Admin::TemplatesController < MmCms::Admin::ApplicationController

  before_filter :setup

  def index

  end

  protected

  def setup
    @mainmenu_id = 'templates'
  end

end