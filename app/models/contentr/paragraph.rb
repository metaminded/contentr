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

  end
end