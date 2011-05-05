# coding: utf-8

module Contentr
  class Paragraph

    # Includes
    include Mongoid::Document

    # Fields
    field :area_name, :type => String

    # Validations
    validates_presence_of :area_name

    # Relations
    embedded_in :paragraph

  end
end