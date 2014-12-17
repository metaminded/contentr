require 'spec_helper'

feature 'Pages' do
  scenario 'create a page' do
    login_as_admin
    visit contentr.admin_pages_path
    click_link 'New Page'
    fill_in 'Name', with: 'My first page'
    click_button 'Create Content page'
    expect(page).to have_css('.alert', text: 'successfully created')
  end
end