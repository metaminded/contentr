require 'spec_helper'

feature Contentr::Admin::ContentBlocksController do

  scenario 'is able to add paragraphs to the content block', js: true do
    content_block = create(:content_block, partial: '').reload
    login_as_admin
    visit contentr.admin_area_paragraphs_path(content_block.class.name, content_block.id, 'main')
    expect(page).to have_no_content('Edit Paragraphs')
    click_link 'Main'
    expect(page).to have_content('Edit Paragraphs')
    select 'Standard', from: 'choose-paragraph-type'
    find('#add_paragraph_btn').click
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')
    fill_in 'Headline', with: 'Hello World!'
    fill_in 'Body', with: 'lorem ipsum'
    click_button 'Create Standard paragraph'
    expect(page).to have_css('.existing-paragraphs', count: 1)
    expect(page).to have_css('.existing-paragraphs', text: 'Hello World!')
  end
end
