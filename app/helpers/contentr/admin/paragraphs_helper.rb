# coding: utf-8

module Contentr
  module Admin
    module ParagraphsHelper

      def display_paragraph(p, current = true)
        case p
        when Contentr::HtmlParagraph
          p = p.for_edit if contentr_publisher? && current
          s = p.body.html_safe if p.body
          s += image_tag(p.image.url) if p.image.present?
        end
        s
      end
    end
  end
end
