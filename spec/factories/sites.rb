FactoryGirl.define do
  factory :site, class: Contentr::Site do |s|
    s.position 0
    s.name "cms"
    s.slug "cms"
  end
end
