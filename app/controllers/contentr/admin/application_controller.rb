class Contentr::Admin::ApplicationController < ApplicationController

  before_filter :check_editable

  layout 'contentr_admin'

  def check_editable
    raise "Access Denied" unless contentr_editable?
  end

end