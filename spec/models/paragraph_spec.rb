# coding: utf-8

require 'spec_helper'

class TestParagraph < Contentr::Paragraph
  field :photo, uploader: Contentr::FileUploader
  field :name, type: 'String'
end

def asset(fname)
  File.new(File.join(File.dirname(__FILE__), '..', 'assets', fname))
end

describe Contentr::Paragraph do
  

  its "attributes are saved properly" do
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    tp.save
    tp.unpublished_data["name"].should eq "huhu!"
    tp.reload
    tp.name = "hallo!"
    tp.name.should eq 'hallo!'
    tp.unpublished_data["name"].should eq "huhu!"
    tp.save
    tp.name.should be_nil
    tp.unpublished_data['name'].should eq 'hallo!'
    tp.publish!
    tp.name.should eq 'hallo!'
    tp.unpublished_data['name'].should eq 'hallo!'
    tp.name = "Horst"
    tp.name.should eq "Horst"
    tp.unpublished_data['name'].should eq 'hallo!'
    tp.save
    tp.name.should eq "hallo!"
    tp.unpublished_data['name'].should eq 'Horst'
    tp.revert!
    tp.name.should eq "hallo!"
    tp.unpublished_data['name'].should eq 'hallo!'
  end

  its "attachments" do
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    tp.save
    tp.name = "hallo!"
    tp.photo = asset('tenderlove.png')
    tp.save
    tp.name.should be_nil
    tp.photo.should_not be_present
    tp.reload
    tp.unpublished_data['name'].should eq 'hallo!'
    tp.name.should be_nil
    tp.publish!
    tp.name.should eq 'hallo!'
    tp.photo.should be_present
    tp.photo.url.should match(/file\/tenderlove.png/)
    tp.photo = asset('yehuda.png')
    tp.save
    tp.photo.url.should match(/tenderlove/)
    tp.for_edit.photo.url.should match(/yehuda/)
    tp.publish!
    tp.photo.url.should match(/yehuda/)
    tp.photo = asset('tenderlove.png')
    tp.save
    tp.revert!
    tp.photo.url.should match(/file\/yehuda/)
    tp.for_edit.photo.url.should match(/yehuda/)
    tp2 = TestParagraph.new(name: "aloha!", area_name: 'body')
    tp2.save
    tp2.photo.should_not be_present
    tp2.photo = asset('dhh.jpg')
    tp2.save
    tp2.for_edit.photo.url.should match('dhh.jpg')
    tp2.publish!
    tp2.photo.url.should match(/dhh.jpg/)    
    tp2.image_asset_wrapper_for("photo").remove_file!(tp2)
    tp2.save
    tp2.photo.url.should match(/dhh/)
    tp2.for_edit.photo.should_not be_present
    tp2.publish!
    tp2.photo.should_not be_present
  end

end
