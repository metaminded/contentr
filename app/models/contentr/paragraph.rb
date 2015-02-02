# coding: utf-8

module Contentr
  class Paragraph < ActiveRecord::Base
    include ActionView::Helpers::SanitizeHelper
    include ParagraphFields
    include ParagraphPublishing
    include ParagraphExtension

    default_scope ->{ order(position: :asc) }

    scope :visible_and_not_empty, -> () {
      where(visible: true).
      where.not(data: nil).
      where.not(data: ActiveSupport::HashWithIndifferentAccess.new.to_yaml) }

    permitted_attributes :area_name, :position, :data, :unpublished_data,
      :content_block_to_display_id, {headers: []}

    belongs_to :page, class_name: 'Contentr::Page'
    belongs_to :content_block, class_name: 'Contentr::ContentBlock'

    # Validations
    validates :area_name, presence: true

    attr_accessor :skip_callbacks

    def skip_callbacks?
      skip_callbacks
    end

    after_create do
      update_column(:position, self.id)
    end

    def summary
      return 'Einige Felder des Paragraphen sind ungültig. Bitte ändern Sie die Werte.' unless self.form_fields.present?
      u ||= unpublished_changes?
      self.form_fields.map do |f|
        a = u ? self.unpublished_data[f[:name].to_s] : self.data[f[:name].to_s]
        next unless a.present?
        a = strip_tags(a)
        n = self.class.human_attribute_name(f[:name])
        "#{n}: #{a}"
      end.compact.join('; ').truncate(140, separator: /\s/)
    end

    def self.cache_key
      Digest::MD5.hexdigest("Paragraph-#{self.reorder(updated_at: :desc).limit(1).pluck(:updated_at).first.to_i}")
    end

    def self.cache?
      true
    end

    def self.memoized_cache_key
      RequestStore.store['paragraph_cache_keys'] ||= {}
      RequestStore.store['paragraph_cache_keys'][self.name] ||= self.cache_key
    end
  end
end
