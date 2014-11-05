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

  it '.visible_and_not_empty' do
    p = create(:paragraph, visible: true)
    expect(Contentr::Paragraph.visible_and_not_empty).to be_empty
    p.publish!
    expect(Contentr::Paragraph.visible_and_not_empty).to eq [p]
    p.update(visible: false)
    expect(Contentr::Paragraph.visible_and_not_empty).to be_empty
  end

  it 'does not reset unpublished_data on save' do
    p = create(:paragraph)
    expect(p.body).to_not be_present
    expect(p.unpublished_data[:body]).to be_present
    p.save!
    expect(p.body).to_not be_present
    expect(p.unpublished_data[:body]).to be_present
  end
end
