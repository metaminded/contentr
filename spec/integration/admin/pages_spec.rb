require 'spec_helper'

describe Contentr::Admin::PagesController do
  let!(:site) { FactoryGirl.create(:site, slug: "foobar") }
  let!(:contentpage) { FactoryGirl.create(:contentpage_with_paragraphs) }
  
  describe "#index" do
    before { visit "/contentr/admin/pages" }

    it "has an index path" do
      current_path.should eql contentr_admin_pages_path
    end

    it "has a list of all root pages" do
      page.find(:css, 'table#pages_table').should_not be_nil
    end

    it "has two sites in this list" do
      page.all(:css, 'table#pages_table tbody tr').count.should be(2)
    end

    it "has a create new site link" do
      page.should have_link "Create a new site"
    end

    it "has a link to edit the site" do
      page.find_link("Edit").click
      current_path.should eql edit_contentr_admin_page_path(site, root: nil)
    end

    it "has a link to delete the page" do
      page.find_link("Delete").visible?
    end

    it "lists the current path" do
      page.should have_content("Current Path: /")
    end
  end

  describe "#edit" do
    before { visit edit_contentr_admin_page_path(contentpage, root: nil)}

    it "shows the values of the current page" do
      page.find_field("page_name").value.should == contentpage.name
    end

    it "shows the paragraphs of the page" do
      page.all(:css, '.paragraph').count.should be(2)
    end

    it "deletes a paragraph when i click on delete" do
      within("#paragraph_1") do
        page.find_link("Delete").click
      end
      contentpage.should  have(1).paragraphs
    end

    it "shows the unpublished version of a paragraph if there is one" do
      para = Contentr::Paragraph.find(contentpage.paragraphs.first.id)
      para.body = "hell yeah!"
      para.save!
      visit("/contentr/admin/pages/#{para.page_id}/edit")
      page.should have_content("hell yeah!")
    end
  end

end
