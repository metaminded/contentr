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
          page_or_pages = (path.blank? or path == :root or path.strip == '/') ? Contentr::Page.roots.asc(:position).to_a
                                                                              : Contentr::Page.find_by_path(path)
          return nil if page_or_pages.blank?
        end

        # set default depth
        options[:depth] = options[:depth] || 0

        # walk the tree(s)
        page_or_pages.is_a?(Array) ? _page_tree(page_or_pages, current_page, options)
                                   : _page_tree(page_or_pages.children, current_page, options)
      end

      protected

      def _page_tree(nodes, current_page, options, depth = -1)
        # Calc the current depth
        depth = depth + 1
        # Render ...
        if nodes.present?
          content_tag(:ul, :class => "contentr #{options[:class] || 'menu'}") do
            nodes.collect do |p|
              # ignore hidden pages
              next if p.hidden?
              # ignore unpublished pages
              next unless p.published?
              # return if we reached max depth
              return nil if depth > options[:depth]

              # render li tag
              li_options = {}
              content_tag(:li, li_options) do
                # default
                s = ''

                # the link url
                link_url = p.is_link? ? url_for(p.controller_action_url_options.merge(:only_path => false))
                                      : File.join(Contentr.frontend_route_prefix, p.path)
                link_options = {}
                # set the link css class
                link_classes = []
                # mark active (current) page
                link_classes << 'active'  if p == current_page
                # mark descendant pages of current page
                link_classes << 'open' if current_page.descendant_of?(p)
                # set the link classes
                link_options[:class] = link_classes.join(' ') unless link_classes.empty?
                # set link title
                link_title = p.menu_title || p.name
                # the link
                s << link_to(link_title, link_url, link_options)

                # the children
                s << _page_tree(p.children, current_page, options, depth).to_s

                # safe we are
                s.html_safe
              end
            end.join("").html_safe
          end
        end
      end

    end
  end
end