#coding: utf-8

require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def setup
    clean_mongodb
  end

  test 'pages can only have page childs' do
    page = Contentr::Page.create!(name: 'page1')
    assert_raise Contentr::UnsupportedChildNodeError do
      Contentr::Node.create!(name: 'node', parent: page)
    end
  end

end
