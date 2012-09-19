class ApplicationController < ActionController::Base
  protect_from_forgery

  def contentr_authorized?
    true # In a real app override this with
  end
end
