# coding: utf-8

require 'spec_helper'

describe Contentr::Page do
  after(:all) do
    Contentr::Node.delete_all
  end

  it 'site must be a root' do
    site1 = Contentr::Site.new(name: 'site1')
    site1.should be_valid
    site1.save!
    site2 = Contentr::Site.new(name: 'site1', parent: site1)
    site2.should be_invalid
  end

  it 'page must have parent' do
    page = Contentr::Page.new(name: 'page1')
    page.should be_invalid
  end

  it 'the parent of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site')
    page = Contentr::Page.new(name: 'page', parent: site)
    site.should be_valid
    page.should be_valid

    node = Contentr::Node.create!(name: 'node')
    page = Contentr::Page.new(name: 'page', parent: node)
    node.should be_valid
    page.should be_invalid
  end

  its 'children of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site')
    page = Contentr::Page.create!(name: 'page', parent: site)
    site.should be_valid
    page.should be_valid

    node = Contentr::Node.new(name: 'node', parent: page)
    node.should be_invalid
  end
end
