require 'spec_helper'

describe "pages" do
  
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

  describe "#index" do
    before { visit "/contentr/admin/pages" }

    it "has an index path" do
      current_path.should eql contentr_admin_pages_path
    end

    it "has a list of all root pages" do
      page.find(:css, 'table#pages_table').should_not be_nil
    end

    it "has one page in this list" do
      page.all(:css, 'table#pages_table tbody tr').count.should be(1)
    end

    it "has a create new page button" do
      page.should have_content "Create a new page"
    end

    it "has a link to edit the page" do
      page.find_link("Edit").click
      current_path.should eql edit_contentr_admin_page_path(@p, root: nil)
    end
  end

  describe "#edit" do
    before { visit edit_contentr_admin_page_path(@p, root: nil)}

    it "shows the values of the current page" do
      page.find_field("page_name").value.should == @p.name
    end

    it "shows the paragraphs of the page" do
      page.all(:css, '.paragraph').count.should be(2)
    end

    it "deletes a paragraph when i click on delete" do
      within("#paragraph_1") do
        page.find_link("Delete").click
      end
      @p.should  have(2).paragraphs
    end

  end


end
