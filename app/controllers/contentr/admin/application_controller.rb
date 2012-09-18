class Contentr::Admin::ApplicationController < Contentr::ApplicationController

  before_filter :check_authorization

  layout :get_layout

  def check_authorization
    raise "Access Denied" unless contentr_authorized?
  end

  def get_layout
    request.xhr? ? nil : 'contentr_admin'
  end

end
