FactoryGirl.define do
  factory :page_type, class: Contentr::PageType do |s|
    s.name "name"
    s.col1_width 4
    s.col2_width 8
    s.col3_width 8
    s.header_allowed_paragraphs '*'
    s.col1_allowed_paragraphs '*'
    s.col2_allowed_paragraphs '*'
    s.col3_allowed_paragraphs '*'
  end
end
