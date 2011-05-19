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

      def menu(menu_name)
        if (menu_name.present?)
          menu_name = menu_name.to_s
          content_tag(:ul) do
            content_tag(:li, 'TODO')
          end
        end
      end

    end
  end
end