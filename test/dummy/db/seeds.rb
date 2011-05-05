#
# Create some pages
#
home_page = MmCms::Page.create!(:name => 'Home', :description => 'homework')

services_page  = MmCms::Page.create!(:name => 'Services', :description => 'what we do')
portfolio_page = MmCms::Page.create!(:name => 'Portfolio', :description => 'our work')

subpage_1 = MmCms::Page.create!(:name => 'Services Subpage 1', :parent => services_page)
subpage_2 = MmCms::Page.create!(:name => 'Services Subpage 2', :parent => services_page)

sub_subpage_1 = MmCms::Page.create!(:name => 'Sub Sub Page 1', :parent => subpage_1)

#
# Finished we are!
#
puts "Dummy data created!"