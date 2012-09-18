# coding: utf-8

module Contentr
  class Page < Node

    # Relations
    has_many :paragraphs, class_name: 'Contentr::Paragraph'

    # Protect attributes from mass assignment
    attr_accessible :description, :menu_title, :published, :hidden

    # Node checks
    self.accepted_parent_nodes = [Contentr::Page]
    self.accepted_child_nodes  = [Contentr::Page]


    # Public: Gets the url path without the site name
    #
    # Example:
    #
    #  self.url_path = "/cms/foo/bar"
    #  => "/foo/bar"
    #
    # Returns the path without the site
    def site_path
      "/#{self.url_path.split('/').slice(2..-1).join('/')}"
    end

    # Public: Publishes the caller
    #
    # Sets published to true
    def publish!
      self.update_attribute(:published, true)
    end

    # Public: Checks if a page is visible
    #
    # Returns if visable or not
    def visible?
      self.published? && !self.hidden?
    end

    # Public: Fetches all visible and published children
    #
    # Returns the matching children
    def visible_children
      self.children.where(published: true, hidden: false)
    end

    # Public: gets all area_names of this page's paragraphs
    #
    # Returns an array of the found area_names without duplicates
    def expected_areas
      self.paragraphs.map(&:area_name).uniq
    end


    # Public: Searches for all paragraphs with an exact area_name
    # 
    # area_name - the area_name to search for
    #
    # Returns the matching paragraphs
    def paragraphs_for_area(area_name)
      self.paragraphs.where(area_name: area_name).order(position: :asc)
    end

  end
end
