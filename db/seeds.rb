#
# Create some pages
#
home_page      = MmCms::Page.create!(:name => 'Home', :description => 'homework', :template => 'home')
services_page  = MmCms::Page.create!(:name => 'Services', :description => 'what we do')
portfolio_page = MmCms::Page.create!(:name => 'Portfolio', :description => 'our work')

subpage_1 = MmCms::Page.create!(:name => 'Services Subpage 1', :parent => services_page)
subpage_2 = MmCms::Page.create!(:name => 'Services Subpage 2', :parent => services_page)

sub_subpage_1 = MmCms::Page.create!(:name => 'Sub Sub Page 1', :parent => subpage_1)

#
# Create some data for the homepage
#
home_page.data << MmCms::Data::StringData.new(
  :name  => 'welcome_headline',
  :value => 'Welcome to Defraction! We design beautiful websites!'
)
home_page.data << MmCms::Data::StringData.new(
  :name  => 'message',
  :value => 'Lorem Ipsum is simply dummy text of the printing and typesetting<br />industry. It\'s been the standard dummy text since the 1500\'s!'
)
home_page.save!

#
# Finished we are!
#
puts "Dummy data created!"