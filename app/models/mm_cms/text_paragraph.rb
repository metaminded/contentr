# coding: utf-8

module MmCms
  class TextParagraph < Paragraph

    # Fields
    field :title, :type => String
    field :body,  :type => String

    # Validations
    validates_presence_of :title
    validates_presence_of :body

  end
end