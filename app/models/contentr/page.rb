# coding: utf-8

module Contentr
  class Page

    # Includes
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    # Fields
    field :name,        :type => String
    field :description, :type => String
    field :slug,        :type => String, :index => true
    field :path,        :type => String, :index => true
    field :layout,      :type => String, :default => 'default'
    field :template,    :type => String, :default => 'default'
    field :linkedTo,    :type => String

    # Relations
    embeds_many :paragraphs, :class_name => 'Contentr::Paragraph'

    # Protect attributes from mass assignment
    attr_accessible :name, :description, :slug, :layout, :template, :parent

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug
    validates_presence_of   :layout
    validates_presence_of   :template

    # Callbacks
    before_validation :generate_slug
    before_destroy    :destroy_children
    before_validation :rebuild_path
    after_rearrange   :rebuild_path


    def to_liquid
      Contentr::LiquidSupport::Drops::PageDrop.new(self)
    end

    def self.find_by_path(path)
      Contentr::Page.where(:path => path).first
    end

    def has_children?
      self.children.count > 0
    end

    def is_link?
      self.linkedTo.present?
    end

  protected

    def generate_slug
      self.slug = name.to_url
    end

    def rebuild_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

  end
end
