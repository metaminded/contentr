# coding: utf-8

module MmCms
  module Liquid
    module Drops

      ##
      # TBD
      #
      class ItemDrop < ::Liquid::Drop

        def initialize(item)
          @item = item
        end

        def data
          ItemDataDrop.new(@item.data)
        end

        def name
          @item.name
        end

        def description
          @item.description
        end

        def slug
          @item.slug
        end

      end

      ##
      # TBD
      #
      class ItemDataDrop < ::Liquid::Drop

        def initialize(data)
          @data = data
        end

        # method missing
        def before_method(m)
          @data.each { |d| return d if d.try(:name) == m }
          nil
        end
      end

    end
  end
end