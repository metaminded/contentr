require 'spec_helper'

feature 'Navigation management' do
  scenario 'user removes a nav point', js: true do
    root = create(:nav_point, title: 'de')
    child_lvl_one = create(:nav_point, title: 'child lvl one', parent: root)
    child_lvl_two = create(:nav_point, title: 'child lvl two', parent: child_lvl_one)
    visit contentr.admin_nav_points_path
    expect(page.all('li[data-id]').count).to be 3
    page.find("li[data-id='#{child_lvl_one.id}'] > .remove-nav-point").click
    expect(page.all('li[data-id]').count).to be 1
  end
end
