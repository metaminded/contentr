require 'spec_helper'

RSpec.describe Contentr::Admin::ParagraphsController, type: :controller do
  routes { Contentr::Engine.routes }
  describe "PUT reorder" do
    it 'sorts only paragraphs of the given area' do
      contentpage = create(:contentpage)
      p = create(:paragraph, position: 1, area_name: 'body', page: contentpage)
      p2 = create(:paragraph, position: 2, area_name: 'body', page: contentpage)
      paragraph_in_different_area = create(:paragraph, position: 3, area_name: 'after_content', page: contentpage)
      patch(:reorder, type: 'Contentr::Page', area_containing_element_id: contentpage.id, area_id: 'body', paragraph_ids: "#{p2.id},#{p.id}")
      expect(p.reload.position).to eq(1)
      expect(p2.reload.position).to eq(0)
      expect(paragraph_in_different_area.reload.position).to eq(3)
    end
  end
end