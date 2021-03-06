module Contentr
  module ApplicationHelper
    include Admin::ParagraphsHelper

    def contentr_menu_entries(menu_name, &block)
      raise "No menu name given" if menu_name.blank?
      raise "Block needed" unless block_given?

      if menu_name.is_a?(Contentr::Menu)
        @contentr_menu = menu_name
      else
        @contentr_menu = Contentr::Menu.find_or_create_by(sid: menu_name)
      end

      cache_key = Digest::MD5.hexdigest(@contentr_menu.cache_key(current_user))
      if controller.fragment_exist?(cache_key)
        controller.read_fragment(cache_key)
      else
        output = yield(@contentr_menu.nav_points.includes(page: :displayable))
        controller.write_fragment(cache_key, output)
        output
      end
    end

    # Renders an area of paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_area(area_name, pristine: false, editable: nil)
      raise "No area name given" if area_name.blank?
      if @area_containing_element.present?
        contentr_render_area(area_name, @area_containing_element, pristine: pristine, editable: editable)
      end
    end

    # Renders an area of paragraphs for site paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_site_area(area_name, pristine: false)
      raise "No area name given" if area_name.blank?
      contentr_render_area(area_name, Contentr::Site.current, pristine: pristine)
    end

    # Inserts Google Anylytics into the page
    def contentr_google_analytics
      if Contentr.google_analytics_account.present?
        render(
          partial: 'contentr/google_analytics',
          locals: {
            account_id: Contentr.google_analytics_account
          }
        )
      end
    end

    def contentr_paragraph_labels(paragraph)
      return '' unless allowed_to_interact_with_contentr?
      return '' if paragraph.visible &&
                   (paragraph.unpublished_data.empty? || !paragraph.changed?) &&
                   paragraph.page.present? && paragraph.page.language == I18n.locale.to_s

      content_tag(:div, class: 'contentr-paragraph-labels') do
        concat(content_tag(:span, t('.not_published'), class: 'label label-warning label-unpublished')) unless paragraph.unpublished_data.empty? || !paragraph.changed?
        concat(content_tag(:span, t('.not_visible'), class: 'label label-danger label-not-visible')) unless paragraph.visible
        concat(content_tag(:span, t('.inherit'), class: 'label label-info')) if paragraph.page.present? && paragraph.page.language != I18n.locale.to_s
      end
    end

    def contentr_paragraph_visible_icon(paragraph)
      if paragraph.visible?
        link_to "#{fa_icon(:eye, text: t('.hide'))}".html_safe, contentr.hide_admin_paragraph_path(id: paragraph), class: 'btn btn-small btn-danger pull-right'
      else
        link_to "#{fa_icon(:eye, text: t('.show'))}".html_safe, contentr.display_admin_paragraph_path(id: paragraph), class: 'btn btn-small btn-success pull-right'
      end
    end

    def contentr_edit_page_link(page, klass: 'btn btn-danger')
      # binding.pry
      if page.visible?
        link_to fa_icon(:eye, text: t('contentr.hide_page')),
          contentr.admin_page_path(page, 'page[published]' => '0', return_to: request.path),
          class: klass, 'data-method' => 'patch'
      else
        link_to fa_icon(:eye, text: t('contentr.publish_page')),
          contentr.admin_page_path(page, 'page[published]' => '1', return_to: request.path),
          class: klass, 'data-method' => 'patch'
      end
    end

    private

    def contentr_render_area(area_name, area_containing_element, pristine: false, editable: nil)
      area_name  = area_name.to_s
      authorized = editable.nil? ? allowed_to_interact_with_contentr? : editable
      publisher = contentr_publisher?
      partial = if pristine && !authorized
        'contentr/area_pristine'
      else
        'contentr/area'
      end
      render(
        partial: partial,
        locals: {
          area_containing_element: area_containing_element,
          area: area_name,
          authorized: authorized,
          publisher: publisher,
          mode: 'frontend',
          pristine: pristine
        }
      )
    end

    def contentr_has_authorized_paragraphs?(user, area, authorized)
      area = area.to_s.split('-').first
      allowed_to_interact_with_contentr? && user.try(:allowed_to_use_paragraphs?, area: area) && authorized
    end

    def contentr_can_use_paragraph?(user, area, paragraph)
      area = area.to_s.split('-').first
      allowed_to_interact_with_contentr? && user.try(:allowed_to_use_paragraphs?, area: area, paragraph_class: paragraph)
    end

    def area_name_generated?(area)
      area.to_s.split('-').count > 1
    end

    def show_frontend_subtree(subtree, children)
      return [] if children.empty?
      st = children.keys.collect do |nt|
        next if nt.page.present? && !nt.page.published

        lic = content_tag(:li, :'data-id' => nt.id, class: 'dropdown-submenu') do
          st = show_frontend_subtree(nt, children[nt])
          if st.none?
            l = link_to nt.title, nt.link, class: 'real-link'
          else
            l = link_to nt.title.html_safe, '#', data: {toggle: 'dropdown'}, class: 'dropdown-toggle'
            l + st.join('').html_safe
          end
        end
        lic
      end
      if subtree.parent.nil?
        ul_class = 'nav'
      else
        ul_class = 'dropdown-menu'
      end
      st.prepend("<ul class='col-sm-4 tree #{ul_class}' data-parent='#{subtree.id}'>")
      st.append('</ul>')
      st
    end
  end
end
