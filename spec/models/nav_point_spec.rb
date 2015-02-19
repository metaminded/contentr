require 'spec_helper'

describe Contentr::NavPoint do

  describe 'general stuff' do
    it "works" do
      site = create(:site)
      nav_point = Contentr::NavPoint.create!(title: 'Articles', site: site)
    end
  end

  describe '#only_link?' do
    it 'it knows when its only a link' do
      site = create(:site)
      nav_point = Contentr::NavPoint.create!(title: 'Articles', site: site)
      expect(nav_point.only_link?).to be_truthy
      p = Contentr::Page.new
      nav_point.page = p
      expect(nav_point.only_link?).to be_falsey
    end
  end

  describe '.navigation_tree' do
    it 'gets a tree-like navigation structure' do
      nav_point = create(:nav_point, title: 'root')
      child_nav_point = create(:nav_point, title: 'child', parent: nav_point)
      tree = Contentr::NavPoint.navigation_tree
      keys = tree.keys
      expect(keys.first.title).to eq('root')
      expect(tree[keys.first].count).to eq 1
      expect(tree[keys.first].first.first.title).to eq 'child'
    end
  end

  describe '#link' do
    it 'gets the link for a given locale' do
      nav_point = create(:nav_point_with_alternative_link)
      allow(I18n).to receive(:locale).and_return(:de)
      expect(nav_point.link).not_to eq nav_point.page.url
      expect(nav_point.link).to eq nav_point.alternative_links.first.page.url
    end

    it 'gets the page link if it is the default locale' do
      nav_point = create(:nav_point_with_alternative_link)
      expect(nav_point.link).to eq nav_point.page.url
      expect(nav_point.link).not_to eq nav_point.alternative_links.first.page.url
    end
  end
end
