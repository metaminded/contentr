class ApplicationController < ActionController::Base
  protect_from_forgery

  def contentr_editable?
    true # In a real app override this with an appropriate logic
  end
end
