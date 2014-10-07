require 'spec_helper'

describe "pages" do

  it 'displays the content', js: true do
    site = create(:site, slug: 'en', published: true)
    a = create(:article, title: 'wicked product', body: 'this article is awesome!')
    content_page = create(:contentpage, name: 'info', parent: a.default_page,
      slug: 'info', published: true, page_type: create(:page_type))
    paragraph = create(:paragraph, page: content_page, body: 'hello world!').publish!
    visit "/en/articles/#{a.id}/seiten/info"
    expect(content_page.paragraphs.count).to be 1
    expect(page).to have_content('hello world!')
  end
end
