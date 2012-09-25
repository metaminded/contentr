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

    after_find do
      @data_was = self.data.clone
      @image_was = self.image.clone
      @unpublished_data_was = self.unpublished_data.clone
    end

    before_save do
      return if @_revert_now
      if @data_was
        self.unpublished_data = self.data.clone
        if @image_was.url != self.image.url
          self.image_unpublished = self.image.clone 
        else
          self.image_unpublished = @unpublished_data_was["image_unpublished"]
          self.unpublished_data["image_unpublished"] = @unpublished_data_was["image_unpublished"]
        end
        self.image = @image_was unless @_publish_now
        self.data = @data_was unless @_publish_now
      else
        self.unpublished_data = self.data
      end
    end

    def publish!
      @_publish_now = true
      self.data = unpublished_data.clone
      save!
    end

    def revert!
      @_revert_now = true
      self.unpublished_data = self.data.clone
      save!
    end

    def data_dirty?
      @data_was != data
    end

    def unpublished_changes?
      data != unpublished_data
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
      @attributes['data'].serialized_value
    end

    # Public: Define setter and getter for a ActiveRecord::Store attribute
    #
    # name - the name of the store attribute
    # opts - an optional hash with specific settings
    #
    def self.field(name, opts={})
      store_accessor :data, name
      if opts[:uploader]
        store_accessor :unpublished_data, "#{name}_unpublished"
        uploader = opts[:uploader]
        typ = "file"
        self.send(:define_method, "#{name}_will_change!") do
          self.data_will_change!
        end
        self.send(:define_method, "#{name}_unpublished_will_change!") do
          self.data_will_change!
        end
        self.send(:define_method, "#{name}_changed?") do
          true # self.data_was && data_was[name] != data[name]
        end
        self.send(:define_method, "#{name}_unpublished_changed?") do
          true # self.data_was && data_was[name] != data[name]
        end
        mount_store_uploader :data, name, uploader
        mount_store_uploader :unpublished_data, "#{name}_unpublished", uploader
      elsif false 
          alias_method "#{name}_without_typecast=".to_sym, "#{name}=".to_sym
          typ ||= opts[:type] || "String"
          self.send(:define_method, "#{name}=") do |val|
            self.write_store_attribute(name, val, typ)
          end
      end
      self.form_fields ||= []
      typ ||= "String"
      self.form_fields << {name: name, typ: typ.to_sym}
      attr_accessible name
    end

  end
end

