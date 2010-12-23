# coding: utf-8

module MmCms
  module Liquid
    module Drops

      ##
      # TBD
      #
      class NodeDrop < ItemDrop

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