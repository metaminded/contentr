# coding: utf-8

require 'spec_helper'

class TestParagraph < Contentr::Paragraph
  field :name, type: 'String'
end


describe Contentr::Paragraph do


  it "attributes are saved properly" do
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    tp.save
    expect(tp.unpublished_data["name"]).to eql "huhu!"
    tp.reload
    tp.name = "hallo!"
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data["name"]).to eql "huhu!"
    tp.save
    expect(tp.name).to be_nil
    expect(tp.unpublished_data['name']).to eql 'hallo!'
    tp.publish!
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data['name']).to eql 'hallo!'
    tp.name = "Horst"
    expect(tp.name).to eq 'Horst'
    expect(tp.unpublished_data['name']).to eql 'hallo!'
    tp.save
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data['name']).to eql 'Horst'
    tp.revert!
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data['name']).to eql 'hallo!'
  end
end
