# coding: utf-8

module Contentr
  class TextParagraph < Paragraph

    # Fields
    field :title, :type => String
    field :body,  :type => String

    # Validations
    validates_presence_of :title
    validates_presence_of :body

    # Liquid support
    liquid_methods :title, :body

  end
end