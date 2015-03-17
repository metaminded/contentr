# coding: utf-8

module Contentr
  class ApplicationController < ActionController::Base

    before_filter do
      I18n.locale = params[:locale] || I18n.default_locale
    end
  end
end
