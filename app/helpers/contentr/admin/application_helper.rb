# coding: utf-8

module Contentr
  module Admin
    module ApplicationHelper

      def simple_form_for_contentr_paragraph(&block)
        simple_form_for(
          'paragraph',
          :url     => (@paragraph.new_record? ? contentr_admin_paragraphs_path(:page_id => @page.id, :area_name => @paragraph.area_name, :type => @paragraph.class) : contentr_admin_paragraph_path(:page_id => @page, :id => @paragraph)),
          :method  => (@paragraph.new_record? ? :post : :put),
          :enctype => "multipart/form-data") do |f|
            yield(f) # << f.input(:area_name, :as => :hidden)
          end
      end

    end
  end
end