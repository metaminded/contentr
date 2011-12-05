# coding: utf-8

module Contentr
  class Page < Node

    # Fields
    field :description, :type => String
    field :menu_title,  :type => String
    field :published,   :type => Boolean, :default => false, :index => true
    field :hidden,      :type => Boolean, :default => false, :index => true

    # Protect attributes from mass assignment
    attr_accessible :description, :menu_title, :published, :hidden

    # Paragraphs
    include Contentr::ParagraphsSupport

    # Constraints
    self.accepted_parent_nodes = ["Contentr::Site", "Contentr::Page"]
    self.accepted_child_nodes  = ["Contentr::Page"]


    def site_path
      "/#{self.path.split('/').slice(2..-1).join('/')}"
    end

    def publish!
      self.update_attribute(:published, true)
    end

    def visible?
      self.published? and not self.hidden?
    end

    def visible_children
      self.children.where(published: true, hidden: false)
    end

  end
end
