# coding: utf-8

module Contentr
  class StandardParagraph < Paragraph

    # Fields
    field :headline, type: 'string'
    field :body,     type: 'text'

    validates :headline, presence: true
  end
end
