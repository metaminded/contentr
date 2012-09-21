require 'spec_helper'

describe Contentr::Admin::ParagraphsController do
  
  before do
    @site = Contentr::Site.create!(position: 0, name: "cms", slug: "cms")

    @p = Contentr::ContentPage.new(
      parent: @site,
      position: 0,
      name: "Foo",
      description: "Foo seite",
      slug: "foo",
      published: true,
      hidden: false
    )
    @p.paragraphs << Contentr::HtmlParagraph.new(
      body: %{
        <div class="content-txt start white start">
        <h1><span style="color:#005C94">Agapedia</span> ist die von J&uuml;rgen Klinsmann 1995 gegr&uuml;ndete Stiftung, die Projekte zur F&ouml;rderung von hilfsbed&uuml;rftigen und Not leidenden Kindern aufbaut.
          Ziel aller Ma&szlig;nahmen ist es, betroffenen Kindern direkt zu helfen und gesellschaftliche Entwicklungen durch nachhaltige Projekte zu unterst&uuml;tzen. <span style="color:#005C94">ist eine Manufaktur der Menschlichkeit.</span>
        </h1>
        </div>},
      area_name: "body",
      position: 0
    )
    @p.paragraphs << Contentr::HtmlParagraph.new(
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
    @p.save!
  end

  describe "#edit" do
    before { visit("/contentr/admin/pages/2/paragraphs/1/edit")}

    context "up-to-date" do

      it "has an up-to-date button" do
        page.has_content?("No unpublished changes")
      end

      it "updates its body" do
        fill_in("paragraph_body", with: "Foobar")
        click_button("Save Paragraph")
        page.find(:css, "input#paragraph_body").value.should eql "Foobar"
      end
    end

    context "unpublished changes" do
      
      it "has a publish button" do
        page.has_content?("Publish!")
      end      
    end
  end

  describe "#publish" do

    it "resets the publish button if i click on it" do
      para = Contentr::Paragraph.find(1)
      para.body = "hell yeah"
      para.save!
      visit("/contentr/admin/pages/#{para.page_id}/paragraphs/#{para.id}/edit")
      click_link("Publish!")
      page.has_content?("No unpublished changes")
    end
  end
end
