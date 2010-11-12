module MmCms
  class Page < Item

    # Fields
    field :layout, :default => 'default'

    def layout
      self.read_attribute(:layout) || 'default'
    end

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
  end
end
