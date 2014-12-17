require 'spec_helper'

feature 'Menus' do
  scenario 'create a menu' do
    login_as_admin
    visit contentr.admin_menus_path
    click_link 'New menu'
    fill_in 'Name', with: 'My first menu'
    fill_in 'Sid', with: 'my-first-menu'
    click_button 'Create Menu'
    expect(page).to have_css('.alert', text: 'successfully created')
  end
end