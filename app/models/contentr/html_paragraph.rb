# coding: utf-8


module Contentr
  class HtmlParagraph < Paragraph
    include ActionView::Helpers
    # Fields
    field :body, :type => 'String'
    field :image, :uploader => Contentr::FileUploader

    
    # Validations
    validates_presence_of :body


    def published_version
      s = ""
      s += self.data[:body].html_safe
      s += image_tag(self.image_url) if self.data.has_key?("image")
      s
    end

    def unpublished_version
      s = ""
      s += self.unpublished_data[:body].html_safe
      s += image_tag(self.image_unpublished_url) if self.unpublished_data.has_key?("image_unpublished")
      s
    end
  end
end
