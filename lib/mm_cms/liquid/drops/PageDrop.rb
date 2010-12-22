# coding: utf-8

module MmCms
  module Liquid
    module Drops

      ##
      # TBD
      #
      class PageDrop < ItemDrop

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
  end
end