require 'spec_helper'

feature "pages" do

  scenario 'displays the content', js: true do
    site = create(:site, slug: 'en', published: true)
    a = create(:article, title: 'wicked product', body: 'this article is awesome!').reload
    content_page = create(:page, name: 'info', parent: a.default_page,
      slug: 'info', published: true, page_type: create(:page_type))
    paragraph = create(:paragraph, page: content_page, body: 'hello world!', visible: true)
    paragraph.publish!
    visit "/en/articles/#{a.id}/info"
    expect(content_page.paragraphs.count).to be 1
    expect(page).to have_content('hello world!')
  end

  scenario 'able to create content on a linked page', js: true do
    login_as_admin
    a = create(:article)
    visit article_path(id: a)
    expect(page).to have_no_content('Hello World!')
    click_link 'Body'
    select 'Standard', from: 'choose-paragraph-type'
    find('#add_paragraph_btn').trigger('click')
    expect(page).to have_css('.panel-heading', text: 'Edit Paragraph')
    fill_in 'Headline', with: 'Hello World!'
    fill_in 'Body', with: 'lorem ipsum'
    expect(page).to have_no_css('.paragraph-box .panel-heading')
    click_button 'Create Standard paragraph'
    expect(page).to have_css('.paragraph-box .panel-heading', text: 'Standard paragraph')

    visit article_path(id: a)
    expect(page).to have_content('Hello World!')
  end

  context 'unpublished page' do
    scenario 'an authorized user can see the unpublished page' do
      login_as_admin
      a = create(:article, title: 'wicked product', body: 'this article is awesome!').reload
      content_page = create(:page, name: 'info', parent: a.default_page,
        slug: 'info', published: false, page_type: create(:page_type))
      visit content_page.url
      expect(page.status_code).to be(200)
    end

    scenario 'a non-authorized user gets a 404' do
      a = create(:article, title: 'wicked product', body: 'this article is awesome!').reload
      content_page = create(:page, name: 'info', parent: a.default_page,
        slug: 'info', published: false, page_type: create(:page_type))
      expect{visit content_page.url}.to raise_error(ActionController::RoutingError)
    end
  end
end
