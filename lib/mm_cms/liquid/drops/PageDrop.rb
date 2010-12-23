# coding: utf-8

module MmCms
  module Liquid
    module Drops

      ##
      # TBD
      #
      class PageDrop < NodeDrop

        def layout
          @item.layout
        end

        def template
          @item.template
        end

      end
    end
  end
end