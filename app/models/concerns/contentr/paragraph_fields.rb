module Contentr
  module ParagraphFields
    extend ActiveSupport::Concern

    included do
      store :data
      class_attribute :form_fields
    end

    def field(name)
      ff = self.class.form_fields.select{|f| f[:name].to_s == name.to_s}
      ff.first
    end

    def fields_for_simple_form
      textpatt = /text|descr|content|body/
      ul = {}
      skipped = ["_id", "_type", "position"]
      if self.class.respond_to?(:uploaders)
        ul = self.class.uploaders
        skipped += self.class.uploader_options.map(&:last).map{|h| h[:mount_on]}
      end
      self.form_fields.try(:map) do |f|
        name = f[:name]
        if skipped.member?(name) then nil else
          name = name.to_sym
          value = self[name]
          options = {}
          options[:required] = false
          options[:as] = :text if textpatt.match(name) || f[:type] == :text
          options[:as] = :file if f[:type] == :file
          options[:as] = :hidden if name == :area_name
          [name, options]
        end
      end.try(:compact).presence || []
    end

    module ClassMethods
      def field(name, type: nil, collection: nil)
        store_accessor :data, name.to_s
        self.form_fields ||= []
        type ||= :text
        elem = {name: name, type: type.to_sym}
        if collection.present?
          elem[:collection] = collection
        end
        self.form_fields << elem
        if type == 'Array'
          permitted_attributes name => []
        else
          permitted_attributes name
        end
      end # field
    end # ClassMethods
  end
end
