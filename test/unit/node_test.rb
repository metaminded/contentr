# coding: utf-8

require 'test_helper'

class NodeTest < ActiveSupport::TestCase

  def setup
    clean_mongodb
  end

  test 'create a single node' do
    node = Contentr::Node.create!(name: 'Node1')
  end

  test 'every node must have a name' do
    page = Contentr::Node.new(:name => ' ')
    assert_equal page.valid?, false
  end

  test 'every node has an auto generated slug' do
    page = Contentr::Node.create!(:name => 'Node1')
    assert_equal page.slug, 'node1'
  end

  test 'slug can be set to a custom value' do
    page = Contentr::Node.create!(:name => 'Node1', :slug => 'test-page')
    assert_equal page.slug, 'test-page'
  end

  test 'a (custom) slug matches the format /^[a-z0-9\s-]+$/' do
    page = Contentr::Node.new(:name => 'Some other Page')

    ['abc', '123', '123abc', 'abc123', 'abc-123', 'abc_123', 'abc+123', 'abc_123', 'öäüß'].each do |p|
      page.slug = p
      assert page.valid?, page.errors.full_messages.join('; ')
    end
  end

  test 'a slug is unique within the parent scope' do
    page1 = Contentr::Node.create!(:name => 'Some Page', :slug => 'test-page')
    page2 = Contentr::Node.new(:name => 'Some other Page', :slug => 'test-page')
    assert_equal page2.valid?, false
    assert_equal page2.errors.first[0], :slug
    assert_equal page2.errors.first[1], 'is already taken'
    # .. but we can use the same slug in another parent scope
    page2 = Contentr::Node.new(:name => 'Some other Page', :slug => 'test-page', :parent => page1)
    assert page2.valid?, page2.errors.full_messages.join('; ')
  end

  test 'every node has a generated path' do
    page1 = Contentr::Node.create!(:name => 'Page 1', :slug => 'page1')
    page2 = Contentr::Node.create!(:name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = Contentr::Node.create!(:name => 'Page 3', :slug => 'page3', :parent => page2)
    assert_equal '/page1', page1.path
    assert_equal '/page1/page2', page2.path
    assert_equal '/page1/page2/page3', page3.path
  end

  test 'a path can\'t be set manually' do
    page = Contentr::Node.create!(:name => 'Page 1', :slug => 'page1', :path => 'mooo')
    assert_equal page.path, '/page1'
    assert_raise RuntimeError do
      page.path = 'this_is_not_allowed'
    end
  end

  test 'one can find a node by path' do
    clean_mongodb
    page1 = Contentr::Node.create!(:name => 'Page 1', :slug => 'page1')
    page2 = Contentr::Node.create!(:name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = Contentr::Node.create!(:name => 'Page 3', :slug => 'page3', :parent => page2)
    assert Contentr::Node.find_by_path('/page1')
    assert Contentr::Node.find_by_path('/page1/page2')
    assert Contentr::Node.find_by_path('/page1/page2/page3')
    assert_nil Contentr::Node.find_by_path('/no_such_page')
  end

end
