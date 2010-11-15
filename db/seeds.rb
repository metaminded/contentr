# create some dummy data

home_page = MmCms::Page.create!(:name => 'Home', :template => 'home')
services_page = MmCms::Page.create!(:name => 'Services')
portfolio_page = MmCms::Page.create!(:name => 'Portfolio')

#page2 = MmCms::Page.create!(:name => 'Page 2', :parent => page1)
#page2.data << MmCms::Data::StringData.new(:name => 'foo', :string_value => 'Hello world.')
#page2.data << MmCms::Data::StringData.new(:name => 'bar', :string_value => 'Here we go.')
#page2.save!

puts "Dummy data created!"