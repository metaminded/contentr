require 'spec_helper'

describe  Contentr::Site do
  describe ".new" do
    it 'creates a new site' do
      s = create(:site, name: 'first site')
      expect(Contentr::Site.count).to be 1
      expect(Contentr::Site.first.name).to eq s.name
    end

    it 'fails if there is already a site with the same name' do
      s = create(:site, name: 'foobar', slug: nil)
      s2 = build(:site, name: 'foobar', slug: nil)
      s3 = build(:site, name: 'foo', slug: nil)
      expect(Contentr::Site.count).to be 1
      expect(s2).not_to be_valid
      expect(s3).to be_valid
    end
  end

  describe '#nav_points <<' do
    it 'accepts nav_points' do
      site = build(:site)
      nav_point = build(:nav_point)
      expect{site.nav_points << nav_point}.to change{site.nav_points.length}.from(0).to(1)
    end
  end

  describe "#navigation" do
    it 'returns the navigation tree structure' do
      site = create(:site)
      root_point = create(:nav_point, title: 'root', site: site)
      first_lvl_second = create(:nav_point, title: 'first lvl second', parent: root_point, position: 1, site: site)
      first_lvl_first = create(:nav_point,  title: 'first lvl first', parent: root_point, position: 0, site: site)
      second_lvl_first = create(:nav_point, title: 'second lvl first', parent: first_lvl_second, site: site)
      nav = site.navigation

      # expect(site.node_print(nav)).to eq([])
    end
  end
end
