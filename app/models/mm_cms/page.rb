module MmCms
  class Page < Item
    # Includes
    include Mongoid::Tree
    include Mongoid::Tree::Ordering

    # Fields
    field :path,     :type => String, :index => true
    field :layout,   :type => String, :default => 'default'
    field :template, :type => String, :default => 'default'

    # Protect attributes from mass assignment
    attr_accessible :layout, :template

    # Validation
    validates_presence_of :layout
    validates_presence_of :template

    # Callbacks
    before_destroy    :destroy_children
    before_validation :rebuild_path
    after_rearrange   :rebuild_path

    def self.find_by_path(path)
      MmCms::Page.where(:path => path).first
    end

    def to_liquid
      MmCms::Liquid::Drops::PageDrop.new(self)
    end

  protected

    def rebuild_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

  end
end
