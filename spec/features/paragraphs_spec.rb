require 'spec_helper'

feature 'interact with uploader paragraphs', js: true do

  scenario 'create an image paragraph' do
    login_as_admin
    a = create(:article)
    visit article_path(id: a)
    click_link 'body'
    select 'Image', from: 'choose-paragraph-type'
    find('#add_paragraph_btn').trigger('click')
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')
    page.attach_file 'Image', File.expand_path(File.join(Rails.application.root, '../', 'support', 'dummy.jpg'))
    click_button 'Create Image paragraph'
    expect(page).to have_css('.paragraph-box .panel-heading', text: 'Image paragraph')

    visit article_path(id: a)
    expect(page).to have_css('img[src*="dummy.jpg"]')
  end

  scenario 'updating an image paragraph without updating the image' do
    login_as_admin
    a = create(:article)
    visit article_path(id: a)
    click_link 'body'
    select 'Image', from: 'choose-paragraph-type'
    find('#add_paragraph_btn').trigger('click')
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')
    page.attach_file 'Image', File.expand_path(File.join(Rails.application.root, '../', 'support', 'dummy.jpg'))
    click_button 'Create Image paragraph'
    expect(page).to have_css('.paragraph-box .panel-heading', text: 'Image paragraph')
    find('.paragraph-edit-btn').click
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')

    expect(page).to have_css('img[src*="dummy.jpg"]')
    click_button 'Update Image paragraph'
    expect(page).to have_css('.paragraph-box .panel-heading', text: 'Image paragraph')
    find('.paragraph-edit-btn').click
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')

    visit article_path(id: a)
    expect(page).to have_css('img[src*="dummy.jpg"]')
  end

end
