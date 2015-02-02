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

    def image_asset_wrapper_for(name, klaz=nil)
      if data["#{name}_id"].present?
        Contentr::ImageAsset.find(data["#{name}_id"])
      else
        klaz.try :new
      end
    end

    module ClassMethods
      def self.dynamic_accessor(name, postfix='')
        define_method("#{name}#{postfix}".to_sym) do |i|
          self.send("#{name}#{i}#{postfix}".to_sym)
        end
      end

      def field(name, type: nil, collection: nil, uploader: nil)
        if uploader
          uploader_field(name, uploader)
          type = "file"
        else
          store_accessor :data, name.to_s
        end
        self.form_fields ||= []
        type ||= :text
        elem = {name: name, type: type.to_sym}
        if collection.present?
          elem[:collection] = collection
        end
        self.form_fields << elem
        if self.respond_to? :permitted_attributes
          if type == 'Array'
            permitted_attributes name => []
          else
            permitted_attributes name
          end
        end
      end # field

      def uploader_field(name, uploader)
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
        define_method "remove_#{name}" do
          false
        end
        define_method "remove_#{name}=" do |x|
          return unless [1, '1', true, 't', 'true'].member?(x)
          ia = image_asset_wrapper_for(name, asset_class)
          ia.remove_file_unpublished!
          ia.save!
          self.send "#{name}_id=", ia.id
        end
      end # uploader_field

      def _uploader_wrappers
        @_uploader_wrappers ||= []
      end

    end # ClassMethods
  end
end
