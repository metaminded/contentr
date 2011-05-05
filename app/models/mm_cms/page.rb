# coding: utf-8

module MmCms
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

    # Relations
    embeds_many :paragraphs, :class_name => 'MmCms::Paragraph'

    # Protect attributes from mass assignment
    # attr_accessible :layout, :template
    # attr_accessible :name, :description, :layout, :template
    # attr_accessible :path, :parent

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug
    validates_presence_of   :layout
    validates_presence_of   :template
    validates_exclusion_of  :name, :in => %w( admin )

    # Callbacks
    before_validation :generate_slug
    before_destroy    :destroy_children
    before_validation :rebuild_path
    after_rearrange   :rebuild_path


    def to_liquid
      MmCms::Liquid::Drops::PageDrop.new(self)
    end

    def self.find_by_path(path)
      MmCms::Page.where(:path => path).first
    end

    def has_children?
      self.children.count > 0
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
