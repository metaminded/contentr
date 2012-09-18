# coding: utf-8

module Contentr
  class Paragraph < ActiveRecord::Base

    store :data


    attr_accessible :area_name, :position, :data
    
    class_attribute :form_fields

    belongs_to :page, class_name: 'Contentr::Page'

    # Validations
    validates_presence_of :area_name

    # Scopes
    default_scope order("position asc")

    def self.dynamic_accessor(name, postfix='')
      define_method("#{name}#{postfix}".to_sym) do |i|
        self.send("#{name}#{i}#{postfix}".to_sym)
      end
    end

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

    def write_store_attribute(name, value, typ)
      v = case typ
        when "Text", "String", String then value.to_s
        when "Integer", "Fixnum", Fixnum then value.to_i
        when "Float", Float then value.to_f
        when "Boolean" then !!value
        when "file" then value
        else raise "Unknown type #{typ}"
      end
      #debugger
      self.send("#{name}_without_typecast=", v)
    end

    def self.field(name, opts={})
      store_accessor :data, name
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

