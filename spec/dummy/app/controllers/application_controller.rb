class ApplicationController < ActionController::Base
  protect_from_forgery

  def contentr_publisher?
    true
  end
end
