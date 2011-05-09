# coding: utf-8

module Contentr
  class HtmlParagraph < Paragraph

    # Fields
    field :body, :type => String

    # Validations
    validates_presence_of :body

    # Liquid support
    liquid_methods :body

  end
end