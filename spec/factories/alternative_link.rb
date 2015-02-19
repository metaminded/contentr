FactoryGirl.define do
  factory :alternative_link, class: Contentr::AlternativeLink do |s|
    association :page, factory: :page
    s.language :de
  end
end
