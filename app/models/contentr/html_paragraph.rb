# coding: utf-8

module Contentr
  class HtmlParagraph < Paragraph

    # Fields
    #field :body, :type => String

    # Validations
    validates_presence_of :body

  end
end
