# coding: utf-8

module Contentr
  class Site < Page

    # Node checks
    self.accepted_parent_nodes = [:root]
    self.accepted_child_nodes  = [Contentr::Page]

    # Public: Gets the default site
    #
    # Returns the default site from the db
    def self.default
      self.where(name: Contentr.default_site).first
    end

    # Public: Gets the default_page
    #
    # Returns the first children of the caller
    def default_page
      self.children.first
    end

  end
end
