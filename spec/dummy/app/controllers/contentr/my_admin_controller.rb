class Contentr::MyAdminController < Contentr::Admin::ApplicationController
  def contentr_authorize!(type:, object:)
    super
  end
end