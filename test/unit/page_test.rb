#coding: utf-8

require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def setup
    clean_mongodb
  end

  test 'pages can only have page childs' do
    root = Contentr::Node.create!(name: 'root')
    page = Contentr::Page.create!(name: 'page1', parent: root)
    assert_raise Contentr::UnsupportedChildNodeError do
      Contentr::Node.create!(name: 'node', parent: page)
    end
  end

  test 'pages can not be a root node' do
    assert_raise Contentr::UnsupportedParentNodeError do
      Contentr::Page.create!(name: 'page1')
    end
  end

end
