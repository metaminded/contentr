require 'spec_helper'

describe Contentr::Admin::ParagraphsController do

  let!(:site) { FactoryGirl.create(:site, slug: "foobar") }
  let!(:contentpage) { FactoryGirl.create(:contentpage_with_paragraphs) }

  describe "#edit" do
    before { visit("/contentr/admin/pages/#{contentpage.id}/paragraphs/#{contentpage.paragraphs.first.id}/edit")}

    context "up-to-date" do

      it "has an up-to-date button" do
        page.has_content?("No unpublished changes")
      end

      it "has no revert button" do
        page.should_not have_button("Revert")
      end 

      it "updates its body" do
        fill_in("paragraph_body", with: "Foobar")
        click_button("Save Paragraph")
        visit("/contentr/admin/pages/#{contentpage.id}/paragraphs/#{contentpage.paragraphs.first.id}/edit")
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
      @para = contentpage.paragraphs.first
      @para.body = "hell yeah"
      @para.save!
      visit("/contentr/admin/pages/#{@para.page_id}/paragraphs/#{@para.id}/edit")
      click_link("Publish!")
      page.has_content?("No unpublished changes")
    end
  end

end
