require 'spec_helper'

describe 'contentr/content_blocks/content_block' do
  it  'renders a partial if it is set' do
    cb = build(:content_block)
    cb.partial = '_article'
    # assign(:content_block, cb)
    create(:site)
    create(:article, title: 'first product')
    create(:article, title: 'second one')

    render 'contentr/content_blocks/content_block', content_block: cb

    expect(rendered).to match /first product/
    expect(rendered).to match /second one/
  end

  it 'renders paragraphs if they are set' do
    cb = build(:content_block)
    paragraph = create(:paragraph, body: 'this is a paragraph of a contentblock.')
    paragraph.publish!
    cb.partial = nil
    cb.paragraphs << paragraph

    render 'contentr/content_blocks/content_block', content_block: cb

    expect(rendered).to match /this is a paragraph of a contentblock./
  end
end
