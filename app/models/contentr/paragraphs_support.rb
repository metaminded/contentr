module Contentr
  module ParagraphsSupport

    def self.included(base)
      base.class_eval <<-RUBY
        embeds_many :paragraphs, :class_name => 'Contentr::Paragraph' #, :cascade_callbacks => true
      RUBY
    end

    def expected_areas
      paragraphs.map(&:area_name).uniq
    end

    def paragraphs_for_area(area_name)
      paragraphs.where(area_name: area_name).order_by([[:position, :asc]])
    end

  end
end