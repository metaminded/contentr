require 'test_helper'

class PageTest < ActiveSupport::TestCase

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

    assert_equal '/page1', page1.path
    assert_equal '/page1/page2', page2.path
  end

end