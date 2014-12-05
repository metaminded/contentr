module Contentr
  class ContentBlock < ActiveRecord::Base
    include ContentBlockExtension

    has_many :paragraphs, dependent: :destroy, before_add: :set_actual_position,
             inverse_of: :content_block, class_name: 'Contentr::Paragraph'
    has_many :usages, dependent: :destroy, inverse_of: :content_block_to_display,
      class_name: 'Contentr::ContentBlockParagraph', foreign_key: :content_block_to_display_id

    validates :name, presence: true
    validate :partial_xor_paragraphs

    def set_actual_position(paragraph)
      last_position = Contentr::Paragraph.order('position DESC').find_by(content_block: self)
      paragraph.position = last_position.position + 1 if last_position
    end

    # Public: Searches for all paragraphs with an exact area_name
    #
    # area_name - the area_name to search for
    #
    # Returns the matching paragraphs
    def paragraphs_for_area(area_name, inherit: true)
      paragraphs = self.paragraphs.order('position asc')
      paragraphs
    end

    def self.available_partials
      Dir.glob("#{Rails.root}/app/views/contentr/content_blocks/**/*").map do |partial|
        partial.scan(%r{/app/views/contentr/content_blocks/_(.*)\.html.*\z}).flatten.first
      end
    end

    private

    def partial_xor_paragraphs
      if [partial, paragraphs].compact.select(&:present?).count > 1
        errors.add(:partial, :partial_and_paragraphs_are_mutual_exclusive)
      end
    end
  end
end
