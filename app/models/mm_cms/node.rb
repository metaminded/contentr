# coding: utf-8

module MmCms
  class Node < Item

    # Includes
    include Mongoid::Tree
    include Mongoid::Tree::Ordering

    # Fields
    field :path, :type => String, :index => true

    # Protect attributes from mass assignment
    attr_accessible :path

    # Callbacks
    before_destroy    :destroy_children
    before_validation :rebuild_path
    after_rearrange   :rebuild_path

    def self.find_by_path(path)
      MmCms::Node.where(:path => path).first
    end

    def to_liquid
      MmCms::Liquid::Drops::NodeDrop.new(self)
    end

  protected

    def rebuild_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

  end
end