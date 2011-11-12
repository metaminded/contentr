# coding: utf-8

#
# Clear mongo db first
#
Mongoid.master.collections.select do |collection|
  collection.name !~ /system/
end.each(&:drop)

#
# Create a site
#
site = Contentr::Site.create!(name: 'cms')

#
# Create some pages
#
home_page = Contentr::ContentPage.create!(name: 'Home', description: 'homework', parent: site)
home_page.publish!

portfolio_page = Contentr::ContentPage.create!(name: 'Portfolio', description: 'our work', parent: site)
portfolio_page.publish!

services_page  = Contentr::ContentPage.create!(name: 'Services', description: 'what we do', parent: site)
services_page.publish!

subpage_1 = Contentr::ContentPage.create!(name: 'Services Subpage 1', parent: services_page)
subpage_1.publish!

sub_subpage_1 = Contentr::ContentPage.create!(name: 'Sub Sub Page 1', parent: subpage_1)
sub_subpage_1.publish!

subpage_2 = Contentr::ContentPage.create!(name: 'Services Subpage 2', parent: services_page)
subpage_2.publish!

#
# Create some content on the pages
#
p = Contentr::HtmlParagraph.new(area_name: 'body', body: 'Contentr <b>is</b> cool! Some non ASCII chars: üöß')
home_page.paragraphs << p
p = Contentr::HtmlParagraph.new(area_name: 'body', body: 'Contentr <b>is even</b> cooler :-)')
home_page.paragraphs << p

#
# Create some articles
#
Article.delete_all
first_article = Article.create!(title: 'Article No. 1', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
Article.create!(title: 'Article No. 2', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
Article.create!(title: 'Article No. 3', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')

#
# Mount/Link a "real" page (controler/action) to a Contentr Page
#
linked_page = Contentr::LinkedPage.create!(name: 'Articles', linked_to: 'articles#index', parent: services_page)
linked_page.paragraphs << Contentr::HtmlParagraph.new(area_name: 'body', body: 'Content for articles#index')
linked_page.publish!

#linked_page = Contentr::ContentPage.create!(name: 'Article', parent: linked_page, :linked_to => 'articles#show')
#linked_page.paragraphs << Contentr::HtmlParagraph.new(area_name: 'body', body: 'Content for articles#show')
#linked_page.publish!

#linked_page = Contentr::ContentPage.create!(name: "Article ID #{first_article.id}", :linked_to => "articles#show:#{first_article.id}")
#linked_page.paragraphs << Contentr::HtmlParagraph.new(area_name: 'body', body: "Content for articles#show:#{first_article.id}")
#linked_page.publish!


#
# Finished we are!
#
puts "Dummy data created!"