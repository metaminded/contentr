# coding: utf-8

class Contentr::ApplicationController < ApplicationController
  # FIXME: hack to make mongoid inheritance work. It seems that preload models
  # does not work right in dev mode.
  Contentr::ContentPage
  Contentr::LinkedPage
  Contentr::Site
  Contentr::Page
  Contentr::Node
  # end hack
end