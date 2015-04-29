require 'spec_helper'

feature 'paragraphs', js: true do

  scenario 'validations are performed on create' do
    login_as_admin
    visit article_path(id: create(:article))
    click_link 'Body'
    select 'Standard', from: 'choose-paragraph-type'
    find('#add_paragraph_btn').trigger('click')
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')
    fill_in 'Headline', with: ''
    fill_in 'Body', with: 'foo bar'
    click_button 'Create Standard paragraph'
    sleep 1
    expect(page).to have_css('.paragraph-edit-box .panel-heading')
    expect(page).to_not have_css('.paragraph-box .panel-heading')
    expect(page).to have_css('.standard_paragraph_headline.error', text: "can't be blank")
  end

  scenario 'validations are performed on update' do
    cp = create(:contentpage_with_paragraphs).reload
    login_as_admin
    visit cp.url
    # visit article_path(id: create(:article))
    click_link 'Body'
    find(".panel[data-paragraph-id='#{cp.paragraph_ids.first}'] .paragraph-edit-btn").trigger('click')
    expect(page).to have_css('.paragraph-edit-box .panel-heading', text: 'Edit Paragraph')
    fill_in 'Headline', with: ''
    click_button 'Update Standard paragraph'
    sleep 1
    expect(page).to have_css('.paragraph-edit-box .panel-heading')
    expect(page).to have_css('.standard_paragraph_headline.error', text: "can't be blank")
  end

end
