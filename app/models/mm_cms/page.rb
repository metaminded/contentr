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
      PageLiquidProxy.new(self)
    end

  protected

    def rebuild_path
      self.path = self.ancestors_and_self.collect(&:slug).join('/')
    end

  end

  ##
  # TBD
  #
  class PageLiquidProxy < ItemLiquidProxy
    def layout
      @item.layout
    end

    def template
      @item.template
    end

    def path
      @item.path
    end

    def has_children
      @item.children.count > 0
    end

    def children
      @item.children.asc(:position)
    end
  end
end
