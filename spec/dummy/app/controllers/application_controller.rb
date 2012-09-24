class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :contentr_publisher?

  def contentr_authorized?
    true # In a real app override this
  end

  def contentr_publisher?
    true
  end
end
