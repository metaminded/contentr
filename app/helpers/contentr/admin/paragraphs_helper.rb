# coding: utf-8

module Contentr
  module Admin
    module ParagraphsHelper

      def display_paragraph(p)
        case p
        when Contentr::HtmlParagraph
          if contentr_publisher?
            s = p.unpublished_data[:body].html_safe if p.unpublished_data.has_key?(:body)
            s += image_tag(p.image_unpublished_url) if p.unpublished_data.has_key?("image")
          else
            s = p.data[:body].html_safe if p.data.has_key?(:body)
            s += image_tag(p.image_url) if p.data.has_key?("image")
          end
        end
      end
    end
  end
end
