module Contentr
  module MenuHelper

    # Renders a dynamic menu
    def menu(options = {})
      # set the current page
      current_page = options[:page] || @_contentr_current_page
      return if current_page.blank? or not current_page.is_a?(Contentr::Page)

      # create a dummy root page
      root_page = Contentr::Page.new
      root_page.children = Contentr::Page.roots.asc(:position)

      # get ancestors of the current page and set the dummy root
      # page as a single root node
      ancestors = current_page.ancestors_and_self
      ancestors = [root_page] + ancestors

      # set start level
      start_level = (options[:start] || 0).to_i
      ancestors = ancestors[start_level..-1] || []

      # set the depth
      depth = (options[:depth] || 1).to_i

      # render function
      fn = lambda do |pages, current_depth|
        # pagees present?
        return '' unless pages.present?
        # max depth?
        return '' if current_depth > depth
        # remove every hidden or unpublished pages
        # FIXME: implement this as part of the node api
        pages = pages.map{|p| p if p.published? and not p.hidden?}.compact

        # render the ul tag
        content_tag(:ul) do
          pages.each_with_index.collect do |page, index|
            # options for the li tag
            li_options = {}
            # css classes
            css_classes = []
            # each li is an item
            css_classes << "item"
            # mark active (current) page
            css_classes << (options[:active_class] || 'active')  if page == current_page
            # mark descendant pages of current page
            css_classes << (options[:open_class] || 'open') if current_page.descendant_of?(page)
            # mark the current depth
            css_classes << "depth-#{page.depth}"
            # mark the first one
            css_classes << "first" if index == 0
            # mark the last one
            css_classes << "last" if index >= (pages.size-1)
            # set the link css classes
            li_options[:class] = css_classes.join(' ')

            # render li tag
            content_tag(:li, li_options) do
              # default
              s = ''.html_safe
              # the link
              s << contentr_page_link(page)
              # the children
              s << fn.call(page.children, current_depth + 1)
            end
          end.join("").html_safe
        end
      end

      # render yo
      if ancestors.present?
        pages = ancestors.first.children
        if pages.present?
          content_tag(:div, :class => "contentr #{options[:class] || 'menu'}") do
            fn.call(pages, 1)
          end
        end
      end
    end

    # Renders a breadcrumb
    def breadcrumb(options = {})
      if current_page.present?
        content_tag(:ul, :class => "contentr #{options[:class] || 'breadcrumb'}") do
          current_page.ancestors_and_self.collect do |page|
            # li tag options
            li_options = {}
            # css classes
            css_classes = []
            # each li is an item
            css_classes << "item"
            # mark active (current) page
            css_classes << (options[:active_class] || 'active')  if page == current_page
            # set the link css classes
            li_options[:class] = css_classes.join(' ')
            # render li tag
            content_tag(:li, li_options) { contentr_page_link(page) }
          end.join("").html_safe
        end
      end
    end

    private

    def contentr_page_link(page)
      # set url
      link_url = page.is_link? ? page.controller_action_url_options
                               : File.join(Contentr.frontend_route_prefix, page.path)
      # set link title
      link_title = page.menu_title || page.name

      # the link
      link_to(link_title, link_url)
    end

  end
end