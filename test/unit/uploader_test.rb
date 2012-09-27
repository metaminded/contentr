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
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
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
  end
  
  test "attachments" do
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    assert tp.save
    tp.name = "hallo!"
    tp.photo = asset('tenderlove.png')
    assert tp.save
    assert_equal nil, tp.name
    assert !tp.photo.present?
    tp.reload
    puts tp.photo
    assert_equal 'hallo!', tp.unpublished_data['name']
    assert_equal nil, tp.name
    tp.publish!
    assert_equal 'hallo!', tp.name
    assert tp.photo.present?
    assert_match /file\/tenderlove.png/, tp.photo.url
    tp.photo = asset('yehuda.png')
    tp.save
    assert_match /tenderlove/, tp.photo.url
    assert_match /yehuda/, tp.for_edit.photo.url
    tp.publish!
    assert_match /file\/yehuda.png/, tp.photo.url
    tp.photo = asset('tenderlove.png')
    tp.save
    tp.revert!
    assert_match /yehuda/, tp.photo.url
    assert_match /yehuda/, tp.for_edit.photo.url
  end



end
