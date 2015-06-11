FormTranslation.config do |ft|
  ft.default_language = :en
  ft.foreign_languages = [:de]
  ft.translation_column = :payload
end

Contentr.register_paragraph(Contentr::StandardParagraph, 'Standard', position: 1)
Contentr.register_paragraph(Contentr::ImageParagraph, 'Image', position: 2)
