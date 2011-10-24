# coding: utf-8

module Contentr
  class Node

    # Includes
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    # Fields
    field :name,   :type => String
    field :slug,   :type => String, :index => true
    field :path,   :type => String, :index => true

    # Protect (other) attributes from mass assignment
    attr_accessible :name, :slug, :parent

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug, scope: :parent_id, allow_nil: false, allow_blank: false
    validates_format_of     :slug, with: /^[a-z0-9\s-]+$/
    validates_presence_of   :path
    validates_uniqueness_of :path, allow_nil: false, allow_blank: false

    # Enforcements
    class_attribute :should_enforce_root_node
    self.should_enforce_root_node = false
    class_attribute :accepted_child_nodes
    self.accepted_child_nodes = []

    # Callbacks
    before_validation :generate_slug
    before_validation :rebuild_path
    before_save       :enforce_root_node
    before_save       :enforce_child_nodes
    before_destroy    :destroy_children

    # Scopes
    default_scope :order => 'position ASC'


    def self.find_by_path(path)
      self.where(path: path).try(:first)
    end

    def has_children?
      children.count > 0
    end

    def path=(value)
      raise "path is generated and can't be set manually."
    end

    def slug=(value)
      self.write_attribute(:slug, value.to_slug) if value.present?
    end

    protected

    def enforce_root_node
      raise MustBeARootNodeError if self.should_enforce_root_node? and not self.root?
    end

    def enforce_child_nodes
      if parent.present?
        raise UnsupportedChildNodeError unless parent.accepts_child?(self)
      end
    end

    def accepts_child?(node)
      return true if self.accepted_child_nodes.empty?
      self.accepted_child_nodes.include?(node.class.name)
    end

    def generate_slug
      if name.present? && slug.blank?
        self.slug = name.to_slug
      end
    end

    def rebuild_path
      self.write_attribute(:path, "/#{ancestors_and_self.collect(&:slug).join('/')}")
    end

  end

  class UnsupportedChildNodeError < RuntimeError; end

  class MustBeARootNodeError < RuntimeError; end

end
