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
end
