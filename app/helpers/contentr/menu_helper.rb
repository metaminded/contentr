require 'ostruct'

module Contentr
  module MenuHelper

    # Renders a dynamic menu
    def contentr_menu(options = {})
      # set the current page
      current_page = options[:page] || @contentr_page
      return "" unless current_page
      # get ancestors of the current page or take the default page if no current page set
      ancestors = current_page ?
        current_page.ancestors :
        Contentr::Site.default.default_page.ancestors

      # set start level
      start_level = (options[:start] || 0).to_i
      ancestors = ancestors[start_level..-1] || []
      # set the depth
      depth = (options[:depth] || 1).to_i

      # render function
      fn = lambda do |pages, current_depth|
        # pages present?
        return '' unless pages.present?
        # max depth?
        return '' if current_depth > depth

        # render the ul tag
        content_tag(:ul) do
          pages.each_with_index.collect do |page, index|
            next if page.hidden #and not contentr_authorized?
            next unless page.published #or contentr_authorized?

            # options for the li tag
            li_options = {}
            # css classes
            css_classes = []
            # each li is an item
            css_classes << "item"
            # mark active (current) page
            css_classes << (options[:active_class] || 'active')  if page == current_page
            # mark descendant pages of current page
            css_classes << (options[:open_class] || 'open') if current_page && current_page.descendant_of?(page)
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
        pages = ancestors.first.children #.where(published: true, hidden: false)
        if pages.present?
          content_tag(:div, :class => "contentr #{options[:class] || 'menu'}") do
            fn.call(pages, 1)
          end
        end
      end
    end

    # Renders a breadcrumb
    def contentr_breadcrumb(options = {})
      current_page = @contentr_page
      if current_page.present?
        content_tag(:ul, :class => "contentr #{options[:class] || 'breadcrumb'}") do
          current_page.ancestors.collect do |page|
            next unless page.is_a?(Contentr::Page)
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
          end.join('').html_safe
        end
      end
    end

    private

    def contentr_page_link(page)
      # we have a menu_only "page"
      if !page.is_a?(Contentr::Page)
        return content_tag(:span, :class => "contentr-menu-entry") do
          page.name
        end
      end
      # set url
      #link_url = page.is_link? ? page.url_for_linked_page
      #                         : File.join('/', Contentr.default_site, page.path)
      link_url = ::File.join('/', page.site_path)

      # set link title
      link_title = page.menu_title || page.name

      # the link
      link_to(link_title, link_url)
    end

  end
end
