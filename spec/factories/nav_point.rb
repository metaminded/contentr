FactoryGirl.define do
  factory :nav_point, class: Contentr::NavPoint do |s|
    s.title "nav point"
    s.url 'google.com'

    factory :nav_point_with_alternative_link do
      url ''
      before(:create) do |nav_point, evaluator|
        nav_point.page = create(:contentpage)
        nav_point.alternative_links << create(:alternative_link)
      end
    end
  end
end
