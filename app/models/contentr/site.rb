# coding: utf-8

module Contentr
  class Site < Node

    # Contraints
    self.accepted_parent_nodes = [:root]
    self.accepted_child_nodes  = ["Contentr::Page"]


    def self.find_by_name(name)
      self.where(slug: name).first
    end

    def default_page
      self.children.first
    end

  end
end
