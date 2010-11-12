# create some dummy data

page1 = MmCms::Page.create!(:name => 'Page 1')
page2 = MmCms::Page.create!(:name => 'Page 2', :parent => page1)

page2.data << MmCms::Data::StringData.new(:name => 'foo', :string_value => 'Hello world.')
page2.data << MmCms::Data::StringData.new(:name => 'bar', :string_value => 'Here we go.')
page2.save!

puts "Dummy data created!"