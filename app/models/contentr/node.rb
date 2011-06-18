# coding: utf-8

module Contentr
  class Node

    # Node is not abstract any more :)

    # Includes
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    # Fields
    field :name,   :type => String
    field :slug,   :type => String, :index => true
    field :path,   :type => String, :index => true
    field :hidden, :type => Boolean, :default => false, :index => true

    # Protect (other) attributes from mass assignment
    attr_accessible :name, :slug, :parent

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug, :scope => :parent_id, :allow_nil => false, :allow_blank => false
    validates_format_of     :slug, :with => /^[a-z0-9\s-]+$/
    validates_presence_of   :path
    validates_uniqueness_of :path

    # Callbacks
    before_validation :generate_slug
    before_destroy    :destroy_children
    before_validation :rebuild_path
    after_rearrange   :rebuild_path


    def self.find_by_path(path)
      if path.present? and path.start_with?(Contentr.frontend_route_prefix)
        path = path.slice(Contentr.frontend_route_prefix.length..path.length)
      end
      Contentr::Page.where(:path => path).try(:first)
    end

    def has_children?
      children.count > 0
    end

    def path=(value)
      raise "path is generated an can't be set"
    end

    def slug=(value)
      self.write_attribute(:slug, value.to_slug) if value.present?
    end

    def published?
      true
    end

  protected

    def generate_slug
      if name.present? && slug.blank?
        self.slug = name.to_slug
      end
    end

    def rebuild_path
      self.write_attribute(:path, "/#{ancestors_and_self.collect(&:slug).join('/')}")
    end

    # BUGFIX: It looks like mongoid/tree or mongoid returns the wrong order
    #def ancestors
    #  base_class.where(:_id.in => parent_ids).reverse if parent_ids
    #end

  end
end
