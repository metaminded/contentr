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
    p = p.for_edit
    p.save!
    expect(p.body).to_not be_present
    expect(p.unpublished_data[:body]).to be_present
  end

  it 'is visible after visible_at and before hide_at' do
    p = build(:paragraph, visible: true, visible_at: Time.new(2015, 3, 23, 10, 0), hide_at: Time.new(2015, 3, 24, 10, 0))
    travel_to Time.new(2015, 3, 23, 10, 0) do
      expect(p).to be_currently_visible
    end
    travel_to Time.new(2015, 3, 24, 10, 1) do
      expect(p).to_not be_currently_visible
    end
  end

  it 'is visible after visible_at if hide_at is not set' do
    p = build(:paragraph, visible: true, visible_at: Time.new(2015, 3, 23, 10, 0))
    travel_to Time.new(2015, 3, 22, 14, 0) do
      expect(p).to_not be_currently_visible
    end
    travel_to Time.new(2015, 3, 23, 12, 0) do
      expect(p).to be_currently_visible
    end
  end

  it 'is visible before hide_at if visible_at is not set' do
    p = build(:paragraph, visible: true, hide_at: Time.new(2015, 3, 23, 10, 0))
    travel_to Time.new(2015, 3, 22, 10, 0) do
      expect(p).to be_currently_visible
    end
    travel_to Time.new(2015, 3, 23, 10, 0) do
      expect(p).to_not be_currently_visible
    end
  end

  it 'uses the visible attribute if both visible_at and hide_at are not set' do
    p = build(:paragraph, visible: true)
    expect(p).to be_currently_visible
    p.visible = false
    expect(p).to_not be_currently_visible
  end


  it 'generates different cache_keys depending on currently_visible?' do
    p = create(:paragraph, visible: true, visible_at: Time.new(2015, 10, 10, 15, 30))
    hidden_cache_key   = nil
    visible_cache_key = nil
    travel_to Time.new(2015, 9, 9, 12, 12) do
      hidden_cache_key = p.class.cache_key
    end
    travel_to Time.new(2015, 11, 11, 12, 12) do
      visible_cache_key = p.class.cache_key
    end
    expect(visible_cache_key).to_not eq hidden_cache_key
  end
end
