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
      self.find_or_create_by_slug_and_name!(Contentr.default_site, Contentr.default_site)
    end

    # Public: Gets the default_page
    #
    # Returns the first children of the caller
    def default_page
      self.children.first
    end

  end
end
