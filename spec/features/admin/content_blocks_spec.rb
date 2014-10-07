require 'spec_helper'

describe Contentr::Admin::ContentBlocksController do
  describe '#paragraphs' do

    it 'is able to add paragraphs to the content block', js: true do
      content_block = create(:content_block, partial: '').reload
      visit contentr.admin_content_block_paragraphs_path(content_block_id: content_block)
      # within('.new-paragraph-buttons') do
      #   click_link 'HTML'
      # end
      # within('.existing-paragraphs') do
      #   fill_in 'Body', with: 'hello world!'
      #   click_button 'Save Paragraph'
      # end
      # expect(page.find(".existing-paragraphs")).to have_content('hello world!')
    end
  end
end
