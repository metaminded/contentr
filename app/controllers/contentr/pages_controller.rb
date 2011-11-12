# coding: utf-8

# FIXME: hack to make mongoid inheritance work. It seems that preload models
# does not work right in dev mode.
Contentr::ContentPage
Contentr::LinkedPage
Contentr::Site
Contentr::Page
Contentr::Node
# end hack

class Contentr::PagesController < ApplicationController

  # The default action to render a view
  def show; end

end