# coding: utf-8

module Contentr
  class HtmlParagraph < Paragraph
    include ActionView::Helpers
    # Fields
    field :body, :type => 'String'
    field :image, :uploader => Contentr::FileUploader

    
    # Validations
  end
end
