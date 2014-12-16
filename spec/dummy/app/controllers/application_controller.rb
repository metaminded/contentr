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

end
