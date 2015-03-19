module Contentr
  module ParagraphContainingElement

    def types_for_area(area_name, inherit: true)
      @_grouped_types ||= {}
      if @_grouped_types.empty?
        grouped_types = select_types
        if grouped_types.none? && try(:page_in_default_language).present? && inherit
          grouped_types = page_in_default_language.select_types
        end
        grouped_types.each do |gt|
          @_grouped_types[gt.area_name] = gt.types
        end
      end
      @_grouped_types[area_name] ||= []
    end

    def select_types
      if self.class.connection.adapter_name.downcase.to_sym == :postgresql
        paragraphs.unscope(:order).select('array_agg(type ORDER BY position ASC) as types, area_name, NULL as data').group(:area_name)
      else
        paragraph_types = {}
        pars = paragraphs.select("type, area_name, 'unused' as data")
        pars.each do |par|
          paragraph_types[par.area_name] ||= OpenStruct.new({area_name: par.area_name, types: []})
          paragraph_types[par.area_name].types << par.type
        end
        paragraph_types.map(&:last)
      end
    end
  end
end
