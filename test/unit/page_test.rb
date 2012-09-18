# coding: utf-8

require 'test_helper'

class PageTest < ActiveSupport::TestCase

  test 'a site must be a root' do
    site1 = Contentr::Site.new(name: 'site1')
    assert site1.valid?
    site1.save!
    site2 = Contentr::Site.new(name: 'site1', parent: site1)
    assert site2.invalid?
  end

  test 'a page must have parent' do
    page = Contentr::Page.new(name: 'page1')
    assert page.invalid?
  end

  test 'the parent of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site')
    page = Contentr::Page.new(name: 'page', parent: site)
    assert  site.valid?
    assert  page.valid?

    node = Contentr::Node.create!(name: 'node')
    page = Contentr::Page.new(name: 'page', parent: node)
    assert  node.valid?
    assert  page.invalid?
  end

  test 'the children of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site')
    page = Contentr::Page.create!(name: 'page', parent: site)
    assert  site.valid?
    assert  page.valid?

    node = Contentr::Node.new(name: 'node', parent: page)
    assert node.invalid?
  end

end
