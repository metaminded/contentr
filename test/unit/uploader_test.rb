require 'test_helper'

class TestParagraph < Contentr::Paragraph
  field :photo, uploader: Contentr::FileUploader
  field :name, type: 'String'
end

class UploaderTest < ActiveSupport::TestCase

  def log(m)
    Rails.logger.info ":::TESTLOG::: #{m}"
  end

  def asset(fname)
    File.new(File.join(File.dirname(__FILE__), '..', 'assets', fname))
  end

  test "A attribute publishing test" do
    site = Contentr::Site.create!(name: 'Site')
    page = Contentr::ContentPage.create!(name: 'Page', parent: site)
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    #page.paragraphs << tp
    assert tp.save
    assert_equal "huhu!", tp.unpublished_data["name"]
    tp.reload
    tp.name = "hallo!"
    assert_equal 'hallo!', tp.name
    assert_equal "huhu!", tp.unpublished_data['name']
    assert tp.save
    assert_equal nil, tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']    
    tp.publish!
    assert_equal 'hallo!', tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']
    tp.name = "Horst"
    assert_equal "Horst", tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']
    assert tp.save
    assert_equal 'hallo!', tp.name
    assert_equal 'Horst', tp.unpublished_data['name']
    tp.revert!
    assert_equal 'hallo!', tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']
  end #if false

  test "attachments" do
    site = Contentr::Site.create!(name: 'Site')
    page = Contentr::ContentPage.create!(name: 'Page', parent: site)
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    #page.paragraphs << tp
    assert tp.save
    tp.name = "hallo!"
    tp.photo = asset('tenderlove.png')
    assert tp.save
    assert_equal nil, tp.name
    assert_equal nil, tp.photo
    tp.reload
    puts tp.photo
    assert_equal 'hallo!', tp.unpublished_data['name']
    assert_equal nil, tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']
    tp.publish!
    tp.reload
    assert_equal 'hallo!', tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']
    
    tp.name = "Horst"
    assert_equal "hallo!", tp.name
    assert_equal 'Horst', tp.unpublished_data['name']
    assert tp.save
    tp.reload
    assert_equal 'hallo!', tp.name
    assert_equal 'Horst', tp.unpublished_data['name']
    tp.revert!
    tp.reload
    assert_equal 'hallo!', tp.name
    assert_equal 'hallo!', tp.unpublished_data['name']
  end



end
