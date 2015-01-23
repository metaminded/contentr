class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Contentr::Linkable

  protect_from_forgery with: :exception

  def contentr_authorized?(type:, object:)
    current_contentr_user.contentr_authorized?(type: type, object: object)
  end

  def contentr_authorize!(type:, object:)

  end

  def allowed_to_interact_with_contentr?
    if current_contentr_user.class.name == 'Contentr::AdminUser'
      true
    else
      false
    end
  end

end
