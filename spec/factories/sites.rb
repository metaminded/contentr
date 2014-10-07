FactoryGirl.define do
  factory :site, class: Contentr::Site do |s|
    s.name "cms"
    s.slug "cms"
    s.language "en"
  end
end
