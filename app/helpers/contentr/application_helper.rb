module Contentr
  module ApplicationHelper

    # Returns the current cms page
    def current_page
      @_contentr_current_page
    end

    # Renders an area of paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def area(area_name)
      if current_page.present? and area_name.present?
        area_name = area_name.to_s
        paragraphs = current_page.paragraphs_for_area(area_name)
        editable = controller.contentr_editable?

        area_options = {}
        area_classes = []
        area_classes << 'contentr'
        area_classes << 'area'
        area_classes << 'editable' if controller.contentr_editable?
        area_options[:class] = area_classes.join(' ')
        area_options['data-contentr-area'] = area_name

        content_tag(:div, area_options) do
          s = ''.html_safe

          if editable
            s << content_tag(:div, :class => 'contentr toolbar') do
              'AREA TOOLBAR'
            end
          end

          s << paragraphs.collect do |p|
            template_name = p.class.to_s.tableize.singularize

            paragraph_options = {}
            paragraph_classes = []
            paragraph_classes << 'contentr'
            paragraph_classes << 'paragraph'
            paragraph_classes << 'editable' if editable
            paragraph_options[:class] = paragraph_classes.join(' ')

            content_tag(:div, paragraph_options) do
              s = ''.html_safe

              if editable
                s << content_tag(:div, :class => 'contentr toolbar') do
                  'PARAGRAPH TOOLBAR'
                end
              end

              s << render(:partial => "contentr/paragraphs/#{template_name}", :locals => {:paragraph => p})
            end
          end.join("").html_safe
        end
      end
    end

    # Renders the contentr toolbar in the page
    def contentr_toolbar(options = {})
      if controller.contentr_editable?
        content_tag(:div, :class => 'contentr toolbar') do
          'CONTENTR TOOLBAR'
        end
      end
    end

  end
end