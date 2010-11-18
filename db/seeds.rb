# create some dummy data

home_page      = MmCms::Page.create!(:name => 'Home', :description => 'homework', :template => 'home')
services_page  = MmCms::Page.create!(:name => 'Services', :description => 'what we do')
portfolio_page = MmCms::Page.create!(:name => 'Portfolio', :description => 'our work')

subpage_1 = MmCms::Page.create!(:name => 'Services Subpage 1', :parent => services_page)
subpage_2 = MmCms::Page.create!(:name => 'Services Subpage 2', :parent => services_page)

sub_subpage_1 = MmCms::Page.create!(:name => 'Sub Sub Page 1', :parent => subpage_1)

#page2 = MmCms::Page.create!(:name => 'Page 2', :parent => page1)
#page2.data << MmCms::Data::StringData.new(:name => 'foo', :string_value => 'Hello world.')
#page2.data << MmCms::Data::StringData.new(:name => 'bar', :string_value => 'Here we go.')
#page2.save!

puts "Dummy data created!"