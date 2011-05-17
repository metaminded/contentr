# coding: utf-8

module Contentr
  class Page

    # Includes
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    # Fields
    field :name,               :type => String
    field :description,        :type => String
    field :slug,               :type => String,  :index => true
    field :path,               :type => String,  :index => true
    field :layout,             :type => String,  :default => 'default'
    field :template,           :type => String,  :default => 'default'
    field :linked_to,          :type => String,  :index => true
    field :hide_in_navigation, :type => Boolean, :default => false

    # Relations
    embeds_many :paragraphs, :class_name => 'Contentr::Paragraph'

    # Protect attributes from mass assignment
    attr_accessible :name, :description, :slug, :layout, :template, :parent, :linked_to, :hide_in_navigation

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug
    validates_presence_of   :layout
    validates_presence_of   :template
    validates_uniqueness_of :linked_to, :allow_nil => true, :allow_blank => true
    validates_uniqueness_of :path

    # Callbacks
    before_validation :generate_slug
    before_destroy    :destroy_children
    before_validation :rebuild_path
    after_rearrange   :rebuild_path


    def to_liquid
      Contentr::LiquidSupport::Drops::PageDrop.new(self)
    end

    def self.find_by_path(path)
      if path.present? and path.start_with?(Contentr.frontend_route_prefix)
        path = path.slice(Contentr.frontend_route_prefix.length..path.length)
      end
      Contentr::Page.where(:path => path).try(:first)
    end

    def self.find_by_link(path)
      # Try to find by full path
      page = Contentr::Page.where(:linked_to => path).try(:first)

      # Try wildcard match on the last component if any /articles/42 => /articles/*
      # and page is nil
      if page.blank?
        pc = path.split('/')
        pc[pc.length-1] = '*'
        path = pc.join('/')
        page = Contentr::Page.where(:linked_to => path).try(:first)
      end

      # return page
      page
    end

    def has_children?
      self.children.count > 0
    end

    def is_link?
      self.linked_to.present?
    end

    def expected_areas
      self.paragraphs.map(&:area_name).uniq
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
