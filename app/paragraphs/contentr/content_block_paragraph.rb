module Contentr
  class ContentBlockParagraph < Paragraph
    belongs_to :content_block_to_display, class_name: 'Contentr::ContentBlock'

    def content_block
      return nil unless content_block_to_display_id.present?
      Contentr::ContentBlock.find(content_block_to_display_id)
    end

    def summary
      if content_block_to_display_id.present?
        "Inhaltsblock '#{content_block_to_display.name}' ausgewählt"
      else
        "Noch kein Inhaltsblock ausgewählt"
      end
    end

    def self.cache?
      false
    end
  end
end
