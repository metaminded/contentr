# coding: utf-8

require 'spec_helper'

describe Contentr::Page do
  it 'site must be a root' do
    site1 = Contentr::Site.new(name: 'site1', language: 'en')
    expect(site1).to be_valid
    site1.save!
    site2 = Contentr::Site.new(name: 'site1', parent: site1, language: 'en')
    expect(site2).to be_invalid
  end

  it 'the parent of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site', language: 'en')
    page = Contentr::Page.new(name: 'page', parent: site, language: 'en')
    expect(site).to be_valid
    expect(page).to be_valid

    node = Contentr::Page.create!(name: 'node', language: 'en')
    page = Contentr::Page.new(name: 'page', parent: node, language: 'en')
    expect(node).to be_valid
    expect(page).to be_valid
  end

  it 'children of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site', language: 'en')
    page = Contentr::Page.create!(name: 'page', parent: site, language: 'en')
    expect(site).to be_valid
    expect(page).to be_valid

    node = Contentr::Site.new(name: 'node', parent: page, language: 'en')
    expect(node).to be_invalid
  end

  describe '#url' do
    it "gets the url for a main page of an object" do
      site = create(:site, name: 'en', slug: 'en')
      a = Article.create!(title: 'awesome product', body: 'hell yeah!').reload
      expect(a.default_page.url).to eq "/en/articles/#{a.id}"
    end

    it "gets the url for a custom subpage" do
      site = create(:site, name: 'en', slug: 'en')
      a = Article.create!(title: 'awesome product', body: 'hell yeah!')
      custom_page = Contentr::Page.create(name: 'foo', parent: a.default_page, language: 'en').reload
      expect(custom_page.url).to eq "/en/articles/#{a.id}/seiten/foo"
    end
  end
end
