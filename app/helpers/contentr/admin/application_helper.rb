# coding: utf-8

module Contentr
  module Admin
    module ApplicationHelper

      def simple_form_for_contentr_paragraph(area_containing_element, area_name, paragraph, &block)
        url = (paragraph.new_record? ? contentr.admin_area_paragraphs_path(area_containing_element.class.name, area_containing_element.id, area_name, paragraph_type: paragraph.class) :
          contentr.admin_paragraph_path(paragraph))
        simple_form_for(
          paragraph,
          :url     => url,
          :method  => (paragraph.new_record? ? :post : :patch),
          :enctype => "multipart/form-data",
          remote: true,
          data: {id: paragraph.try(:id)},
          html: {class: 'paragraph', role: 'form'}) do |f|
            yield(f)
          end
      end

      def link_to_add_to_subtree(subtree)
        [ link_to(fa_icon('minus-circle'), contentr.admin_nav_point_path(subtree),
            method: :delete, data: {confirm: 'Sind Sie sicher?'}, class: 'btn btn-xs btn-danger remove-nav-point'),
          link_to(fa_icon(:pencil), contentr.edit_admin_nav_point_path(subtree), class: 'btn btn-xs btn-info'),
          link_to(fa_icon('plus-circle'), contentr.new_admin_nav_point_path(parent: subtree), class: 'btn btn-xs btn-primary')
        ].join(' ')
      end

      def show_subtree(children)
        st = children.keys.collect do |nt|
          lic = content_tag(:li, :'data-id' => nt.id) do
            st = show_subtree(children[nt])
            "#{create_nav_point_title_and_buttons(nt)} #{st.join('')}".html_safe
          end
          lic
        end
        st.prepend("<ul class='tree'>")
        st.append('</ul>')
        st
      end

      def create_nav_point_title_and_buttons nt
        content_tag(:div) do
          s = content_tag(:span, class: 'navpoint-title') do
            nt.title
          end
          s += content_tag(:div, class: 'nav-point-buttons pull-right') do
            link_to_add_to_subtree(nt).html_safe
          end
          s
        end.html_safe
      end

      def contentr_title(title)
        content_for(:contentr_title, title)
      end

      def contentr_buttons(buttons)
        content = buttons.collect do |button|
          button[:link_to_options] ||= {}
          link_to "#{fa_icon(button[:icon])} #{button[:text]}".html_safe, button[:target], button[:link_to_options].reverse_merge(class: button[:class])
        end
        content_for(:contentr_buttons, content.join.html_safe)
      end

      def contentr_navigation &block
        content_for(:contentr_navigation, '')
      end

      def path_to_update_area(area_containing_element, area_name)
        contentr.edit_admin_area_path(area_containing_element.class.name, area_containing_element, area_name)
      end

      def method_missing method, *args, &block
        if main_app_url_helper?(method)
          main_app.send(method, *args)
        else
          super
        end
      end

      def respond_to?(method, include_all=false)
        main_app_url_helper?(method) || super
      end

      private

      def main_app_url_helper?(method)
        (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      end
    end
  end
end
