# coding: utf-8

module Contentr
  module Admin
    module ParagraphsHelper

      def get_reorder_path_for(paragraph)
        if paragraph.page_id.present?
          contentr.admin_reorder_paragraphs_path(page_id: paragraph.page_id, area_name: paragraph.area_name)
        elsif paragraph.content_block_id.present?
          contentr.reorder_admin_content_block_paragraphs_path(paragraph.content_block_id)
        else
          nil
        end
      end
    end
  end
end
