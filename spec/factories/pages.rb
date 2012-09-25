FactoryGirl.define do
  factory :contentpage, class: Contentr::ContentPage do |c|
    c.association :parent, factory: :site
    c.position 0
    c.name "Foo"
    c.description "Foo seite"
    c.slug "foo"
    c.published true
    c.hidden false
    factory :contentpage_with_paragraphs do
      after(:create) do |contentpage, evaluator|
        FactoryGirl.create_list(:paragraph, 2, page: contentpage)
      end
    end
  end
end
