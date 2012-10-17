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
    end

    after_validation do
      @_for_edit = false
      #@_new_data = self.data.to_yaml
    end

    def after_save_copy_unpublished()
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
      transaction do
        self.data = self.unpublished_data.clone
        self.class._uploader_wrappers.try :each do |name|
          w = image_asset_wrapper_for name
          next unless w
          w.file = w.file_unpublished
          w.save!
        end
        @_publish_now = true
        save!
      end
    end

    def revert!
      transaction do
        self.unpublished_data = self.data.clone
        self.class._uploader_wrappers.try :each do |name|
          w = image_asset_wrapper_for name
          next unless w
          w.file_unpublished = w.file
          w.save!
        end
        save!
      end
    end

    def data_dirty?
      @data_was != data
    end

    def unpublished_changes?
      data != unpublished_data && unpublished_data.present?
    end

    def for_edit
      @_for_edit = true
      self.data = self.unpublished_data.clone unless self.unpublished_data.empty?
      self
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
      @attributes[store.to_s].try :serialized_value
    end

    # Public: Define setter and getter for a ActiveRecord::Store attribute
    #
    # name - the name of the store attribute
    # opts - an optional hash with specific settings
    #
    def self.field(name, opts={})
      if opts[:uploader]
        uploader_field(name, opts[:uploader])
        typ = "file"
      else
        store_accessor :data, name.to_s
      end
      after_save :after_save_copy_unpublished
      self.form_fields ||= []
      typ ||= "text"
      self.form_fields << {name: name, typ: typ.to_sym}
      attr_accessible name
    end

    def self.uploader_field(name, uploader)
      _uploader_wrappers << name
      store_accessor :data, "#{name}_id"
      self.send(:define_method, "#{name}_will_change!") do
        self.data_will_change!
      end
      self.send(:define_method, "#{name}_changed?") do
        true # self.data_was && data_was[name] != data[name]
      end
      
      # make a nice subclass to hold the actual asset
      asset_class_name = "ImageAsset#{self}#{name.capitalize}".gsub("::","")
      Object.const_set asset_class_name, Class.new(Contentr::ImageAsset)
      asset_class = asset_class_name.constantize
      asset_class.mount_uploader :file, uploader
      asset_class.mount_uploader :file_unpublished, uploader
      # retrieve the wrapping element
      # retrieve the actual IMAGE from the wrapping class
      define_method name do
        ia = image_asset_wrapper_for(name, asset_class)
        @_for_edit ? ia.file_unpublished : ia.file
      end
      # put new image into (existing) wrapper
      define_method "#{name}=" do |file|
        ia = image_asset_wrapper_for(name, asset_class)
        ia.file_unpublished = file
        ia.save!
        self.send "#{name}_id=", ia.id
      end
      asset_class.send(:define_method, "remove_file_unpublished!") do
        super()
        #paragraph.unpublished_data.delete("#{name}_id")
      end
      asset_class.send(:define_method, "remove_file!") do |paragraph|
        paragraph.data.delete("#{name}_id")
        remove_file_unpublished!
      end
    end

    def self._uploader_wrappers
      @_uploader_wrappers ||= []
    end

    def image_asset_wrapper_for(name, klaz=nil)
      if data["#{name}_id"].present?
        Contentr::ImageAsset.find(data["#{name}_id"])
      else
        klaz.try :new
      end
    end    
  end
end

