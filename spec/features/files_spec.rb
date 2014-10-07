require 'spec_helper'

describe "files" do

  before do
    file = File.new(Rails.root + '../support/dummy.jpg')
    @image = Contentr::File.new(description: "test", slug: "test", file:  ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: File.basename(file)))
    file.close
    @image.save
    Capybara.current_driver = :rack_test
    #Rack::Test::UploadedFile.new(Rails.root.join("spec/support/test.png"), 'image/png')
    #@file = Contentr::File.create!(description: "test", slug: "test", file: "favicon.ico")
  end

  context "file is found" do
    it "displays the page name" do
     visit '/file/test'
     expect(response_headers['Content-Type']).to eql 'image/jpeg'
    end
  end

  context "file is not found" do
    it "should redirect to root page" do
      visit "/file/foobar123"
      expect(page.status_code).to be 404
    end
  end
end
