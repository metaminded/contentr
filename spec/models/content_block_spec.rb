require 'spec_helper'

describe Contentr::ContentBlock do
  describe '#pages' do
    it 'can belong to multiple pages' do
      content_block = create(:content_block)
      contentpage = create(:contentpage, name: 'page-one', slug: 'page-one')
      create_list(:content_block_paragraph, 2, page: contentpage, content_block_to_display: content_block)
      expect(content_block.usages.count).to be 2
    end
  end

  describe '#paragraphs' do
    it 'can include multiple paragraphs' do
      content_block = create(:content_block)
      paragraph = build(:paragraph)
      paragraph2 = build(:paragraph, body: 'hello world!')
      content_block.paragraphs << paragraph
      content_block.paragraphs << paragraph2
      expect(content_block.paragraphs.count).to be 2
      expect(content_block.paragraphs.first).to eq paragraph
    end

    it 'sets incrementing position values' do
      content_block = create(:content_block)
      paragraph = build(:paragraph)
      paragraph2 = build(:paragraph)
      content_block.paragraphs << paragraph
      content_block.paragraphs << paragraph2
      expect(paragraph.position).to be 0
      expect(paragraph2.position).to be 1
    end
  end

  describe "#partial_xor_paragraphs" do
    it 'is not valid when it has both partial and paragraphs' do
      content_block = build(:content_block)
      content_block.partial = '_user'
      paragraph = build(:paragraph)
      content_block.paragraphs << paragraph
      expect(content_block).to_not be_valid
    end
    it 'is valid when it has neither partial or paragraphs' do
      content_block = build(:content_block)
      content_block.partial = ''
      expect(content_block).to be_valid
    end
    it 'is valid when it has either partial or paragraphs' do
      content_block = build(:content_block)
      content_block.partial = ''
      paragraph = build(:paragraph)
      content_block.paragraphs
    end
  end
end
