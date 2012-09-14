# coding: utf-8

module Contentr
  class Page < Node

    # Fields
    # field :description, :type => String
    # field :menu_title,  :type => String
    # field :published,   :type => Boolean, :default => false, :index => true
    # field :hidden,      :type => Boolean, :default => false, :index => true

    # Relations
    has_many :paragraphs, class_name: 'Contentr::Paragraph'#, :cascade_callbacks => true

    # Protect attributes from mass assignment
    attr_accessible :description, :menu_title, :published, :hidden

    # Node checks
    self.accepted_parent_nodes = [Contentr::Page]
    self.accepted_child_nodes  = [Contentr::Page]


    def site_path
      "/#{self.path.split('/').slice(2..-1).join('/')}"
    end

    def publish!
      self.update_attribute(:published, true)
    end

    def visible?
      self.published? and not self.hidden?
    end

    def visible_children
      self.children.where(published: true, hidden: false)
    end

    def expected_areas
      self.paragraphs.map(&:area_name).uniq
    end

    def paragraphs_for_area(area_name)
      self.paragraphs.where(area_name: area_name).order_by([[:position, :asc]])
    end

  end
end
