module MmCms
  class Page < Item
    # Fields
    field :layout,   :default => 'default'
    field :template, :default => 'default'

    # Protect attributes from mass assignment
    attr_accessible :layout, :template

    # Validation
    validates_presence_of :layout
    validates_presence_of :template

    # Liquid
    def to_liquid
      PageLiquidProxy.new(self)
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
  end
end
