# coding: utf-8

module Contentr
  class Site < Page

    # Node checks
    self.accepted_parent_nodes = [:root]
    self.accepted_child_nodes  = [Contentr::Page]


    def self.default
      self.where(name: Contentr.default_site).first
    end

    def default_page
      self.children.first
    end

  end
end
