# coding: utf-8

module Contentr
  require "ancestry"
  class Page < ActiveRecord::Base

    has_ancestry

    # Relations
    has_many :paragraphs, class_name: 'Contentr::Paragraph'

    # Protect attributes from mass assignment
    attr_accessible :name, :slug, :position, :parent, :url_path, :description,
                    :menu_title, :published, :hidden, :parent_id, :menu_only


    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_format_of     :slug, with: /^[a-z0-9\s-]+$/
    # validates_presence_of   :path
    # validates_uniqueness_of :path, allow_nil: false, allow_blank: false
    validate                :check_nodes
    validate                :check_slug_uniqueness

    # Node checks
    class_attribute :run_node_checks
    class_attribute :accepted_child_nodes
    class_attribute :accepted_parent_nodes
    self.run_node_checks       = true
    self.accepted_parent_nodes = [:any]
    self.accepted_child_nodes  = [:any]

    # Callbacks
    before_validation :generate_slug
    before_validation :clean_slug
    after_save        :rebuild_path


    # Node checks
    # self.accepted_parent_nodes = [Contentr::Page]
    # self.accepted_child_nodes  = [Contentr::Page]

    # Public: Find a Node by path
    #
    # path - The path to search for
    #
    # Returns the found path
    def self.find_by_path(path)
      self.where(url_path: ::File.join('/', path)).try(:first)
    end

    # Public: Gets the root element
    #
    # Returns the root of the tree the record is in, self for a root node
    def site
      self.root
    end


    # Public: Gets the classname of the page without Contentr in front
    #
    # Returns the class name as a string
    def classname
      self.class.to_s.split("::")[1].capitalize
    end

    # Public: Checks if self is a descendant of node
    #
    # node - The node which might be a direct or indirect ancestor
    #
    # Returns true if self is a descendant, false otherwise
    def descendant_of?(node)
      self.class.descendants_of(node).include?(self)
    end

    # Public: Raises an error if url_path is set directly
    #
    # value - the new value of url_path
    #
    # Returns a runtime error
    def url_path=(value)
      raise "url_path is generated and can't be set manually."
    end


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
      self.paragraphs.where(area_name: area_name).order("position asc")
    end

    # Public: Getter for menu_only attribute
    #
    # Returns true or false
    def menu_only?
      self.menu_only
    end


    protected

    # Protected: Checks if this slug is unique in its scope
    #
    # Adds an error if the slug of the caller is not unique
    def check_slug_uniqueness
      if self.parent
        data = self.parent.children.reject{|s| s == self}
      else
        data = Contentr::Page.roots.reject{|s| s == self}
      end
      errors.add(:slug, "is already taken") if data.map(&:slug).include?(self.slug)
    end


    # Protected: Generates a slug from the name if a slug is not yet set
    #
    # Returns a clean slug
    def generate_slug
      if name.present? && slug.blank?
        self.slug = name.to_slug
      end
    end

    # Protected: Removes unwanted chars from a slug
    #
    # Returns a clean slug
    def clean_slug
     self.slug = slug.to_slug unless slug.blank?
    end

    # Protected: Builts the url_path from ancestry's path
    #
    # Updates the url_path of the caller
    def rebuild_path
      self.update_column(:url_path, "/#{path.collect(&:slug).join('/')}")
    end

    # Protected: Checks if this is a valid node
    #
    # Adding errors if this node is not valid
    def check_nodes
      errors.add(:base, "Unsupported parent node.") unless accepts_parent?(parent)
      errors.add(:base, "Unsupported child node.")  if parent.present? and not parent.accepts_child?(self)
    end

    # Protected: Checks if this node accepts a child node
    #
    # child - the child node to test against
    #
    # Returns true if this child is accepted, false otherwise
    def accepts_child?(child)
      return true if accepted_child_nodes.include?(:any)
      return accepted_child_nodes.any?{ |node_class| node_class.kind_of?(Class) and child.is_a?(node_class) }
    end

    # Protected: Checks if this node accepts a parent
    #
    # parent - the parent node to test against
    #
    # Returns true if this parent is accepted, false otherwise
    def accepts_parent?(parent)
      return true  if self.accepted_parent_nodes.include?(:any)
      return true  if self.is_root? && self.accepted_parent_nodes.include?(:root)
      return false if self.is_root? && !self.accepted_parent_nodes.include?(:root)
      return self.accepted_parent_nodes.any?{ |node_class| node_class.kind_of?(Class) && parent.is_a?(node_class) }
      
    end

  end
end
