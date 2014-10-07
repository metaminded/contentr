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
end
