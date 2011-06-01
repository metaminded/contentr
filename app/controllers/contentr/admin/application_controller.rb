class Contentr::Admin::ApplicationController < ApplicationController

  before_filter :check_editable

  layout :get_layout

  def check_editable
    raise "Access Denied" unless contentr_editable?
  end

  def get_layout
    request.xhr? ? nil : 'contentr_admin'
  end

end