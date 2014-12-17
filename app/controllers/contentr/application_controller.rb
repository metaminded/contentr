# coding: utf-8

module Contentr
  class ApplicationController < ::ApplicationController

  before_filter do
    I18n.locale = params[:locale] || I18n.default_locale
  end
  end
end
