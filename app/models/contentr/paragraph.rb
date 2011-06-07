# coding: utf-8

module Contentr
  class Paragraph

    # Paragraph is abstract
    @abstract_class = true

    # Includes
    include Mongoid::Document

    # Fields
    field :area_name, :type => String

    # Validations
    validates_presence_of :area_name

    # Relations
    embedded_in :page

    def self.dynamic_accessor(name, postfix='')
      define_method "#{name}#{postfix}".to_sym do |i|
        self.send "#{name}#{i}#{postfix}".to_sym
      end
    end
    
    def fields_for_simple_form
      textpatt = /text|descr|content|body/
      ul = {}
      skipped = ["_id", "_type"]
      if self.class.respond_to?(:uploaders)
        ul = self.class.uploaders
        skipped += self.class.uploader_options.map(&:last).map{|h| h[:mount_on]}
      end
      self.fields.map do |f| 
        name = f.first
        if skipped.member?(name) then nil else 
          name = name.to_sym
          options = {}
          options[:as] = :file if ul[name]
          [name, options]
        end
      end.compact
    end

  end
end