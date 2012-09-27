# coding: utf-8

module Contentr
  class Paragraph < ActiveRecord::Base

    store :data
    store :unpublished_data

    attr_accessible :area_name, :position, :data, :unpublished_data

    class_attribute :form_fields

    belongs_to :page, class_name: 'Contentr::Page'

    # Validations
    validates_presence_of :area_name

    after_find :save_old_data

    def save_old_data
      @_data_was = self.data.to_yaml
      logger.info("in after find <<<<<<<#{self.data.keys}")
      logger.info("inf after find <<<<<<<#{self.data.to_yaml}")
    end

    after_validation do
      logger.info("in after validate<<<<<<<#{self.data.keys}")
      @_new_data = self.data.to_yaml
      logger.info("in after validate #{self.data.to_yaml}")
    end

    def after_save_copy_unpublished()
      logger.info("in after save")
      self.update_column(:unpublished_data, self.data.to_yaml)
      self.update_column(:data, @_data_was) if !@_publish_now
      reload
      @_publish_now = false
    end

    # we need to do this since the after_find callbacks are called for the 'fresh'
    # version from the database whose attributes are then copied to self.
    def reload
      super
      save_old_data
      self
    end

    def publish!
      self.data = self.unpublished_data.clone
      @_publish_now = true
      save!
      #@_publish_now = false
    end

    def revert!
      self.unpublished_data = self.data.clone
      save!
    end

    def data_dirty?
      @data_was != data
    end

    def unpublished_changes?
      data != unpublished_data && unpublished_data.present?
    end

    def for_edit
      self.data = self.unpublished_data.clone unless self.unpublished_data.empty?
    end

    # Scopes
    default_scope order("position asc")

    def self.dynamic_accessor(name, postfix='')
      define_method("#{name}#{postfix}".to_sym) do |i|
        self.send("#{name}#{i}#{postfix}".to_sym)
      end
    end

    # Public: Generates the fields for a simple form of a paragraph
    #
    # Returns the generated form
    def fields_for_simple_form
      textpatt = /text|descr|content|body/
      ul = {}
      skipped = ["_id", "_type", "position"]
      if self.class.respond_to?(:uploaders)
        ul = self.class.uploaders
        skipped += self.class.uploader_options.map(&:last).map{|h| h[:mount_on]}
      end
      self.fields.map do |f|
        name = f.first
        if skipped.member?(name) then nil else
          name = name.to_sym
          value = self[name]
          long = value.is_a?(String) && (value.length > 80 || value.include?("\n"))
          options = {}
          options[:required] = false
          options[:as] = :text if textpatt.match(name) || long
          options[:as] = :file if ul[name]
          options[:as] = :hidden if name == :area_name
          [name, options]
        end
      end.compact
    end

    # Public: Updates a specific ActiveRecord::Store  attribute with a typecasted value
    #
    # name - the name of the attribute
    # value - the new value of this attribute
    # typ - the datatype in which the value should be casted
    #
    # calls the generated #{name}_without_typecast method which acts as a setter
    def write_store_attribute(name, value, typ)
      v = case typ
        when "Text", "String", String then value.to_s
        when "Integer", "Fixnum", Fixnum then value.to_i
        when "Float", Float then value.to_f
        when "Boolean" then !!value
        when "file" then value
        else raise "Unknown type #{typ}"
      end
      self.send("#{name}_without_typecast=", v)
    end

    # TODO
    def serialized_store_value(store)
      #debugger
      @attributes[store.to_s].try :serialized_value
    end

    # Public: Define setter and getter for a ActiveRecord::Store attribute
    #
    # name - the name of the store attribute
    # opts - an optional hash with specific settings
    #
    def self.field(name, opts={})
      store_accessor :data, name.to_s
      if opts[:uploader]
        uploader = opts[:uploader]
        typ = "file"
        self.send(:define_method, "#{name}_will_change!") do
          self.data_will_change!
        end
        self.send(:define_method, "#{name}_changed?") do
          true # self.data_was && data_was[name] != data[name]
        end
        mount_store_uploader :data, name, uploader
        attr_accessible "remove_#{name}"
      end
      after_save :after_save_copy_unpublished
      self.form_fields ||= []
      typ ||= "String"
      self.form_fields << {name: name, typ: typ.to_sym}
      attr_accessible name
    end
  end
end

