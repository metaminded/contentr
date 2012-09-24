FactoryGirl.define do
  factory :site, class: Contentr::Site do
    position 0
    name "cms"
    slug "cms"
  end

  factory :contentpage, class: Contentr::ContentPage do
    association :parent, factory: :site
    position 0
    name "Foo"
    description "Foo seite"
    slug "foo"
    published true
    hidden false
    factory :contentpage_with_paragraphs do
      after(:create) do |contentpage, evaluator|
        FactoryGirl.create_list(:paragraph, 2, page: contentpage)
      end
    end
  end

  factory :paragraph, class: Contentr::HtmlParagraph do
    body %{
        <div class="content-txt start white start">
        <h1><span style="color:#005C94">Agapedia</span> ist die von J&uuml;rgen Klinsmann 1995 gegr&uuml;ndete Stiftung, die Projekte zur F&ouml;rderung von hilfsbed&uuml;rftigen und Not leidenden Kindern aufbaut.
          Ziel aller Ma&szlig;nahmen ist es, betroffenen Kindern direkt zu helfen und gesellschaftliche Entwicklungen durch nachhaltige Projekte zu unterst&uuml;tzen. <span style="color:#005C94">ist eine Manufaktur der Menschlichkeit.</span>
        </h1>
        </div>}
    area_name "body"
    position 0
  end

  
end

