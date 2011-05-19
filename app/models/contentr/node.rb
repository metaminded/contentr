# coding: utf-8

module Contentr
  class Node

    # Node is abstract
    @abstract_class = true

    # Includes
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    # Fields
    field :name,        :type => String
    field :slug,        :type => String, :index => true
    field :path,        :type => String, :index => true

    # Protect attributes from mass assignment
    attr_accessible :name, :slug, :parent

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug
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
      self.children.count > 0
    end

  protected

    def generate_slug
      self.slug = name.to_url
    end

    def rebuild_path
      self.path = "/#{self.ancestors_and_self.collect(&:slug).join('/')}"
    end

  end
end
