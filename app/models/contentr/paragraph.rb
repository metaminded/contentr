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

  end
end