require 'spec_helper'

describe Contentr::Admin::PagesController do

  describe '#show' do
    it 'displays the page\'s areas' do
      contentpage_two = create(:contentpage, name: 'bar', slug: 'bar')
      visit contentr.admin_page_path(id: contentpage_two)
      contentpage_two.areas.each do |area|
        expect(page.all('.panel-title')).to have_content(area)
      end
    end

    it 'is able to add paragraphs to areas', js: true do
      contentr_page = create(:contentpage, name: 'bar', slug: 'bar')
      visit contentr.admin_page_path(id: contentr_page)
      within('#area-left_column .new-paragraph-buttons') do
        click_link 'HTML'
      end
      within('.existing-paragraphs form') do
        fill_in 'Body', with: 'hello world!'
        click_button 'Save Paragraph'
      end
      expect(page.find(".paragraph")).to have_content('hello world!')
    end

    it "resets the publish button if i click on it", js: true do
      contentpage = create(:contentpage_with_paragraphs)
      @para = contentpage.paragraphs.first
      @para.body = "hell yeah"
      @para.save!
      visit(contentr.admin_page_path(contentpage))
      expect(page).to_not have_content('No Unpublished Changes')
      within("#paragraph_#{@para.id}") do
        click_link("Publish!")
      end
      expect(page).to have_content("No Unpublished Changes")
    end


    it "shows the paragraphs of the page" do
      contentpage = create(:contentpage_with_paragraphs)
      visit(contentr.admin_page_path(contentpage))
      expect(page.all(:css, '.existing-paragraphs').count).to be(4)
    end

    it "deletes a paragraph when i click on delete" do
      contentpage = create(:contentpage_with_paragraphs)
      expect(contentpage.paragraphs.count).to be 2
      visit(contentr.admin_page_path(contentpage))
      within("#paragraph_1") do
        page.find("a.remove-paragraph-btn").click
      end
      expect(contentpage.paragraphs.count).to be 1
    end

    it "shows the unpublished version of a paragraph if there is one" do
      contentpage = create(:contentpage_with_paragraphs)
      para = contentpage.paragraphs.first
      para.body = "hell yeah!"
      para.save!
      visit(contentr.admin_page_path(contentpage))
      expect(page).to have_content("hell yeah!")
    end

    it 'lets the user add content blocks', js: true do
      create(:site)
      contentpage = create(:contentpage_with_paragraphs)
      article = create(:article, title: 'My new article')
      content_block = create(:content_block, name: 'Artikel anzeigen',
        partial: '_article')
      visit(contentr.admin_page_path(contentpage))
      expect(page.all('.existing-paragraphs')).not_to have_content('Artikel anzeigen')
      within('#area-center_column .new-paragraph-buttons') do
        click_link 'Content Block'
      end
      within('.existing-paragraphs form') do
        select 'Artikel anzeigen', from: 'Content block to display'
        click_button 'Save Paragraph'
      end
      expect(page.find('.existing-paragraphs[data-area="area-center_column"]')).to have_content(article.title)
    end

    it 'loads existing content blocks' do
      create(:site)
      article = create(:article)
      contentpage = create(:contentpage_with_content_block_paragraph)
      visit(contentr.admin_page_path(contentpage))
      expect(page.find('.existing-paragraphs[data-area="area-center_column"]')).to have_content(article.title)
    end
  end

end
