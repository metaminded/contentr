# coding: utf-8

module Contentr
  module LiquidSupport
    module Drops

      class PageDrop < Liquid::Drop

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

        def expected_areas
          @page.expected_areas
        end

        def url
          if @page.is_link?
            @page.linked_to
          else
            "#{Contentr.frontend_route_prefix}/#{@page.path}"
          end
        end

      end
    end
  end
end