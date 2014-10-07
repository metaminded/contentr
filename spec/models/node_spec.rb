# coding: utf-8

require 'spec_helper'

describe Contentr::Page do

  it "create a single node" do
    node = create(:contentpage, name: "Node33")
  end

  it "always has a name" do
    page = build(:contentpage, name: '')
    expect(page).to_not be_valid
  end

  it "has an auto generated slug" do
    page = create(:contentpage, name: "Node44", slug: 'node44')
    expect(page.slug).to eql 'node44'
  end

  it "slug can be set to a custom value" do
    page = create(:contentpage, name: 'Node1', slug: 'test-page')
    expect(page.slug).to eql 'test-page'
  end

  it 'slug matches the format /^[a-z0-9\s-]+$/' do
    page = build(:contentpage, :name => 'Some other Page')

    ['abc', '123', '123abc', 'abc123', 'abc-123', 'abc_123', 'abc+123', 'abc_123', 'öäüß'].each do |p|
      page.slug = p
      expect(page).to be_valid
    end
  end

  it 'slug is unique within the parent scope' do
    page1 = create(:contentpage, :name => 'Some Page', :slug => 'it-page')
    page2 = build(:contentpage, :name => 'Some other Page', :slug => 'it-page')
    expect(page2).to_not be_valid
    expect(page2.errors.first.first).to eql :slug
    expect(page2.errors.first[1]).to eql 'must be unique'
    # .. but we can use the same slug in another parent scope
    page2 = build(:contentpage, :name => 'Some other Page', :slug => 'it-page', :parent => page1)
    expect(page2).to be_valid, page2.errors.full_messages.join('; ')
  end

  it 'has a generated path' do
    site = create(:site)
    page1 = create(:contentpage, name: 'Page 1', slug: 'page1', parent: site).reload
    page2 = create(:contentpage, :name => 'Page 2', :slug => 'page2', :parent => page1).reload
    page3 = create(:contentpage, :name => 'Page 3', :slug => 'page3', :parent => page2).reload
    expect(page1.url_path).to eql '/page1'
    expect(page2.url_path).to eql '/page1/page2'
    expect(page3.url_path).to eql '/page1/page2/page3'

  end

  it 'path can\'t be set manually' do
    page = create(:contentpage, :name => 'Page 1', :slug => 'page1').reload
    expect(page.url_path).to eql '/page1'
    expect{page.url_path = 'this_is_not_allowed'}.to raise_error(RuntimeError)
  end

  it 'one can find a node by path' do
    site = create(:site)
    page1 = create(:contentpage, name: 'Page 1', slug: 'page1', parent: site)
    page2 = create(:contentpage, :name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = create(:contentpage, :name => 'Page 3', :slug => 'page3', :parent => page2)
    expect(Contentr::Page.find_by_path('/page1')).to eq page1
    expect(Contentr::Page.find_by_path('/page1/page2')).to eq page2
    expect(Contentr::Page.find_by_path('/page1/page2/page3')).to eq page3
    expect(Contentr::Page.find_by_path('/no_such_page')).to be_nil
  end
end
