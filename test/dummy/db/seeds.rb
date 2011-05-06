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
p = Contentr::TextParagraph.new(:area_name => 'body', :title => 'Some title', :body => 'Contentr is cool!')
home_page.paragraphs << p
p = Contentr::TextParagraph.new(:area_name => 'body', :title => 'Some other title', :body => 'Contentr is even cooler :-)')
home_page.paragraphs << p


#
# Finished we are!
#
puts "Dummy data created!"