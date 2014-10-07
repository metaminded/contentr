# coding: utf-8

module Contentr
  class Paragraph < ActiveRecord::Base
    include ActionView::Helpers::SanitizeHelper
    include ParagraphFields
    include ParagraphPublishing

    default_scope ->{ order(position: :asc) }

    permitted_attributes :area_name, :position, :data, :unpublished_data,
      :content_block_to_display_id, {headers: []}

    belongs_to :page, class_name: 'Contentr::Page'
    belongs_to :content_block, class_name: 'Contentr::ContentBlock'

    # Validations
    validates :area_name, presence: true, unless: ->{self.content_block.present?}

    after_create do
      update_column(:position, self.id)
    end

    def summary()
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

    def current_context
      return Etikett::GlobalTag.first if content_block.present?
      dpy = page.try(:displayable)
      if dpy
        dpy.try(:master_tag)
      elsif page.parent.present?
        page.parent.displayable.try(:master_tag)
      elsif page.context_tags.present?
        page.context_tags
      else
        Etikett::GlobalTag.first
      end
    end

    def self.belongs_to_paragraph_medium(name, tag = nil, scope = nil, options = {}, context: nil)
      context ||= ->(c){[]}
      options[:class_name] = 'Mediapool::Media'
      @medium_callbacks ||= []
      @medium_callbacks << {name: name, tag: tag, context: context}
      unless self._save_callbacks.select { |cb| cb.kind.eql?(:after) }.collect(&:filter).include?(:set_media_class_tag)
        after_save :set_media_class_tag
        self.class_eval do
          def set_media_class_tag
            self.class.instance_variable_get('@medium_callbacks').each do |mc|
              f_key = self.class.reflect_on_association(mc[:name]).foreign_key
              ActiveRecord::Base.transaction do
                if self.is_a? Contentr::Paragraph
                  Mediapool::MediaUsage.where(useable: self).destroy_all
                end
                if self.unpublished_data["#{mc[:name]}_id"].present?
                  Mediapool::MediaUsage.find_or_create_by!(useable: self, media_id: self.unpublished_data["#{mc[:name]}_id"], active: true)
                end
                if self.data["#{mc[:name]}_id"].present?
                  Mediapool::MediaUsage.find_or_create_by!(useable: self, media_id: self.data["#{mc[:name]}_id"], active: true)
                end
              end
            end
          end
        end
      end
      belongs_to(name, scope, options)
    end
  end
end
