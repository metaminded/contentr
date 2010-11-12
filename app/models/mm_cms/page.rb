module MmCms
  class Page < Item
    # Fields
    field :layout, :default => 'default'
    field :template, :default => 'default'

    def layout
      self.read_attribute(:layout) || 'default'
    end

    def template
      self.read_attribute(:template) || 'default'
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
