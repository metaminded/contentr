# coding: utf-8

module Contentr
  module Admin
    module ApplicationHelper

      def simple_form_for_contentr_paragraph(page, area_name, paragraph, &block)
        simple_form_for(
          paragraph,
          :url     => (paragraph.new_record? ? contentr.admin_page_area_paragraphs_path(page, area_id: area_name, type: paragraph.class.to_s) :
            contentr.admin_page_area_paragraph_path(page, area_name, paragraph)),
          :method  => (paragraph.new_record? ? :post : :patch),
          :enctype => "multipart/form-data",
          remote: true,
          data: {id: paragraph.try(:id)},
          html: {class: 'paragraph', role: 'form'}) do |f|
            yield(f)
          end
      end

      def simple_form_for_content_block_paragraph(paragraph, content_block, &block)
        paragraph.content_block = content_block
        simple_form_for(
          paragraph,
          :url     => (paragraph.new_record? ? contentr.admin_content_block_paragraphs_path(content_block, type: paragraph.class) : contentr.admin_content_block_paragraph_path(content_block, paragraph)),
          :method  => (paragraph.new_record? ? :post : :patch),
          :enctype => "multipart/form-data",
          remote: true,
          data: {id: paragraph.try(:id)}) do |f|
            yield(f)
          end
      end

      def simple_form_for_contentr_file(file, &block)
        simple_form_for(
          'file',
          :url     => (file.new_record? ? contentr.admin_files_path() : contentr.admin_file_path(file)),
          :method  => (file.new_record? ? :post : :put),
          :enctype => "multipart/form-data",
          :html    => {:class => 'form-horizontal'}) do |f|
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
          lic = content_tag(:li, class: 'row', :'data-id' => nt.id) do
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
        content_tag(:div, class: 'row') do
          s = content_tag(:span, class: 'navpoint-title col-xs-8 col-sm-7') do
            nt.title
          end
          s += content_tag(:div, class: 'nav-point-buttons col-xs-4 col-sm-5') do
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
    end
  end
end
