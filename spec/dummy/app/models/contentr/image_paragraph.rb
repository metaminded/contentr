module Contentr
  class ImageParagraph < Paragraph
    field :headline
    field :image, uploader: DummyUploader

    def summary
      ''
    end
  end
end
