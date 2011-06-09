#coding: utf-8

require 'test_helper'

class PageTest < ActiveSupport::TestCase

  test 'every page must have a name' do
    clean_mongodb
    page = Contentr::Page.new(:name => ' ')
    assert_equal page.valid?, false
  end

  test 'every page has an auto generated slug' do
    clean_mongodb
    page = Contentr::Page.create!(:name => 'Some Page')
    assert_equal page.slug, 'some-page'
  end

  test 'one can provide a custom slug' do
    clean_mongodb
    page = Contentr::Page.create!(:name => 'Some Page', :slug => 'test-page')
    assert_equal page.slug, 'test-page'
  end

  test 'a (custom) slug matches the format /^[a-z0-9\s-]+$/' do
    clean_mongodb
    page = Contentr::Page.new(:name => 'Some other Page')

    ['abc', '123', '123abc', 'abc123', 'abc-123', 'abc_123', 'abc+123', 'abc_123', 'öäüß'].each do |p|
      page.slug = p
      assert page.valid?, page.errors.full_messages.join('; ')
    end
  end

  test 'a slug is unique within the parent scope' do
    clean_mongodb
    page1 = Contentr::Page.create!(:name => 'Some Page', :slug => 'test-page')
    page2 = Contentr::Page.new(:name => 'Some other Page', :slug => 'test-page')
    assert_equal page2.valid?, false
    assert_equal page2.errors.first[0], :slug
    assert_equal page2.errors.first[1], 'is already taken'
    # .. but we can use the same slug in another patent scope
    page2 = Contentr::Page.new(:name => 'Some other Page', :slug => 'test-page', :parent => page1)
    assert page2.valid?, page2.errors.full_messages.join('; ')
  end

  test 'every page has a generated path' do
    clean_mongodb
    page1 = Contentr::Page.create!(:name => 'Page 1', :slug => 'page1')
    page2 = Contentr::Page.create!(:name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = Contentr::Page.create!(:name => 'Page 3', :slug => 'page3', :parent => page2)
    assert_equal '/page1', page1.path
    assert_equal '/page1/page2', page2.path
    assert_equal '/page1/page2/page3', page3.path
  end

  test 'a path can\'t be set manually' do
    clean_mongodb
    page = Contentr::Page.create!(:name => 'Page 1', :slug => 'page1', :path => 'mooo')
    assert_equal page.path, '/page1'
    assert_raise RuntimeError do
      page.path = 'this_is_not_allowed'
    end
  end

  test 'one can find a page by path' do
    clean_mongodb
    page1 = Contentr::Page.create!(:name => 'Page 1', :slug => 'page1')
    page2 = Contentr::Page.create!(:name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = Contentr::Page.create!(:name => 'Page 3', :slug => 'page3', :parent => page2)
    assert Contentr::Page.find_by_path('/page1')
    assert Contentr::Page.find_by_path('/page1/page2')
    assert Contentr::Page.find_by_path('/page1/page2/page3')
    assert_nil Contentr::Page.find_by_path('/no_such_page')
  end

  test 'a page may have children' do
    clean_mongodb
    page1 = Contentr::Page.create!(:name => 'Page 1', :slug => 'page1')
    page2 = Contentr::Page.create!(:name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = Contentr::Page.create!(:name => 'Page 3', :slug => 'page3', :parent => page2)
    assert page1.has_children?
    assert page2.has_children?
    assert_equal page3.has_children?, false
    assert_equal page1.children.count, 1
    assert_equal page2.children.count, 1
    assert_equal page3.children.count, 0
  end

end