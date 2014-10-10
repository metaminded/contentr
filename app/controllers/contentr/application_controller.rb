# coding: utf-8

class Contentr::ApplicationController < ApplicationController

  before_filter do
    I18n.locale = params[:locale] || I18n.default_locale
  end

  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_contentr_user, params, self)
  end
end
