require 'spec_helper'

describe Contentr::PageBuilder do
  describe "#create" do
    it 'creates a new page' do
      page_builder = Contentr::PageBuilder.new
      expect(Contentr::Page.count).to be 0
      page_builder.create('my page')
      expect(Contentr::Page.count).to be 1
      expect(Contentr::Page.last.name).to eq 'my page'
    end

    it 'creates a page with a specified slug' do
      page_builder = Contentr::PageBuilder.new
      page_builder.create('my page', slug: 'my-slug')
      expect(Contentr::Page.count).to be 1
      expect(Contentr::Page.last.name).to eq 'my page'
      expect(Contentr::Page.last.slug).to eq 'my-slug'
    end
  end
end
