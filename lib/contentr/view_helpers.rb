module Contentr
  module Rendering
    module ViewHelpers

      def current_page
        @_contentr_current_page
      end

      def area(area_name)
        if @_contentr_current_page.present? and area_name.present?
          area_name = area_name.to_s
          paragraphs = @_contentr_current_page.paragraphs_for_area(area_name)
          content_tag(:div, 'data-contentr-area' => area_name) do
            paragraphs.collect do |p|
              template_name = p.class.to_s.tableize.singularize
              render(:partial => "contentr/paragraphs/#{template_name}", :locals => {:paragraph => p})
            end.join("").html_safe
          end
        end
      end

      def menu(options = {})
        # set the current page
        current_page = @_contentr_current_page
        return nil if current_page.blank?

        # set the root page(s) from where generation starts
        page_or_pages = options[:page] || @_contentr_current_page
        return nil if page_or_pages.blank?
        # by default we start from the current page, but this can be
        # overridden by the :path optiop. If path is blank or '/' we
        # generate the menu starting with the root pages
        if (options.has_key?(:path))
          path = options[:path]
          page_or_pages = (path.blank? or path.strip == '/') ? Contentr::Page.roots.asc(:position).to_a
                                                             : Contentr::Page.find_by_path(path)
          return nil if page_or_pages.blank?
        end

        # set default depth
        options[:depth] = options[:depth] || 0

        # walk the tree(s)
        page_or_pages.is_a?(Array) ? _page_tree(page_or_pages, current_page, options)
                                   : _page_tree([page_or_pages], current_page, options)
      end

      protected

      def _page_tree(nodes, current_page, options, depth = -1)
        depth = depth + 1

        if nodes.present?
          content_tag(:ul) do
            nodes.collect do |p|
              # ignore hidden pages
              next if p.hidden?
              # ignore unpublished pages
              next unless p.published?
              # return if we reached max depth
              puts "P: #{p.depth}"
              puts "options: #{options[:depth]}"
              puts "depth: #{depth}"
              puts "-----"

              return nil if p.depth > options[:depth]

              # create li tag
              content_tag(:li) do
                # default
                s = ''

                # the link
                link_url = p.is_link? ? url_for(p.controller_action_url_options)
                                      : File.join(Contentr.frontend_route_prefix, p.path)
                link_options = {}
                link_options[:class] = 'active' if p == current_page
                link_title = p.menu_title || p.name
                s << link_to("[#{p.depth} - #{options[:depth]}] " + link_title, link_url, link_options)

                # the children
                s << _page_tree(p.children, current_page, options, depth).to_s

                # we are safe
                s.html_safe
              end
            end.join("").html_safe
          end
        end
      end

    end
  end
end