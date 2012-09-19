# encoding: utf-8

site = Contentr::Site.create!(position: 0, name: "cms", slug: "cms")

p = Contentr::ContentPage.new(
  parent: site,
  position: 0,
  name: "Foo",
  description: "Foo seite",
  slug: "foo",
  published: true,
  hidden: false
)
p.paragraphs << Contentr::HtmlParagraph.new(
  body: %{
    <div class="content-txt start white start">
    <h1><span style="color:#005C94">Agapedia</span> ist die von J&uuml;rgen Klinsmann 1995 gegr&uuml;ndete Stiftung, die Projekte zur F&ouml;rderung von hilfsbed&uuml;rftigen und Not leidenden Kindern aufbaut.
      Ziel aller Ma&szlig;nahmen ist es, betroffenen Kindern direkt zu helfen und gesellschaftliche Entwicklungen durch nachhaltige Projekte zu unterst&uuml;tzen. <span style="color:#005C94">ist eine Manufaktur der Menschlichkeit.</span>
    </h1>
    </div>},
  area_name: "body",
  position: 0
)
p.paragraphs << Contentr::HtmlParagraph.new(
  body: %{
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.},
  area_name: "body",
  position: 0
)
p.save!

p = Contentr::ContentPage.new(
  parent: site,
  position: 0,
  name: "Bar",
  description: "Bar seite",
  slug: "bar",
  published: true,
  hidden: false
)
p.paragraphs << Contentr::HtmlParagraph.new(
  body: %{
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.},
  area_name: "body",
  position: 0
)
p.paragraphs << Contentr::HtmlParagraph.new(
  body: %{
    <div class="content-txt start white start">
    <h1><span style="color:#005C94">Agapedia</span> ist die von J&uuml;rgen Klinsmann 1995 gegr&uuml;ndete Stiftung, die Projekte zur F&ouml;rderung von hilfsbed&uuml;rftigen und Not leidenden Kindern aufbaut.
      Ziel aller Ma&szlig;nahmen ist es, betroffenen Kindern direkt zu helfen und gesellschaftliche Entwicklungen durch nachhaltige Projekte zu unterst&uuml;tzen. <span style="color:#005C94">ist eine Manufaktur der Menschlichkeit.</span>
    </h1>
    </div>},
  area_name: "body",
  position: 0
)
p.save!

