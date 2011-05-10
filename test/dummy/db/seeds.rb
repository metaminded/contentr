# coding: utf-8

#
# Clear mongo db first
#
Mongoid.master.collections.select do |collection|
  collection.name !~ /system/
end.each(&:drop)

#
# Create some pages
#
home_page = Contentr::Page.create!(:name => 'Home', :description => 'homework')

services_page  = Contentr::Page.create!(:name => 'Services', :description => 'what we do')
portfolio_page = Contentr::Page.create!(:name => 'Portfolio', :description => 'our work')

subpage_1 = Contentr::Page.create!(:name => 'Services Subpage 1', :parent => services_page)
subpage_2 = Contentr::Page.create!(:name => 'Services Subpage 2', :parent => services_page)

sub_subpage_1 = Contentr::Page.create!(:name => 'Sub Sub Page 1', :parent => subpage_1)

#
# Create some content on the pages
#
p = Contentr::TextParagraph.new(:area_name => 'body', :title => 'Some title', :body => 'Contentr <b>is</b> cool! Some non ASCII chars: üöß')
home_page.paragraphs << p
p = Contentr::TextParagraph.new(:area_name => 'body', :title => 'Some other title', :body => 'Contentr <b>is even</b> cooler :-)')
home_page.paragraphs << p

#
# Create some articles
#
Article.delete_all
Article.create!(:title => 'Article No. 1', :body => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
Article.create!(:title => 'Article No. 2', :body => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
Article.create!(:title => 'Article No. 3', :body => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')

#
# Mount/Link a "real" page (controler/action) to a Contentr Page
#
linked_page = Contentr::Page.create!(:name => 'Articles', :linked_to => '/articles')
linked_page.paragraphs << Contentr::TextParagraph.new(:area_name => 'body', :title => 'Hello from Contentr', :body => 'This is contnt from Contentr on a ERB Page!')

linked_page = Contentr::Page.create!(:name => 'Article', :linked_to => '/articles/*', :hide_in_navigation => true)
linked_page.paragraphs << Contentr::TextParagraph.new(:area_name => 'body', :title => 'Hello from Contentr Wildcard', :body => 'This is contnt from Contentr on a ERB Page!')

#
# Finished we are!
#
puts "Dummy data created!"