require 'spec_helper'

describe "pages" do
  
  let!(:site) { FactoryGirl.create(:site, slug: "foobar") }
  let!(:contentpage) { FactoryGirl.create(:contentpage_with_paragraphs) }

  it "displays the page name" do
    visit "/cms"
    page.should have_content("cms")
  end

  it "has two paragraphs" do
    visit("/cms/foo")
    page.all(:css, '.paragraph').count.should be(2)
  end

  it "has got a link to the parent" do 
    visit "/foo"
    page.find_link("cms")
    click_link("cms")
    current_path.should eql "/"
  end


end
