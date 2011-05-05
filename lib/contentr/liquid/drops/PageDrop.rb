# coding: utf-8

module Contentr
  module Liquid
    module Drops

      class PageDrop < ::Liquid::Drop

        def initialize(page)
          @page = page
        end

        def path
          @page.path
        end

        def has_children
          @page.children.count > 0
        end

        def children
          @page.children.asc(:position)
        end

        def layout
          @page.layout
        end

        def template
          @page.template
        end

        def name
          @page.name
        end

        def description
          @page.description
        end

        def slug
          @page.slug
        end

      end
    end
  end
end