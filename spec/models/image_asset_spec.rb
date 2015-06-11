require 'spec_helper'

describe Contentr::ImageAsset do

  describe '#revert' do
    it "reverts unpublished changes" do
      ia = create(:image_asset)
      expect(ia.file).to_not eq ia.file_unpublished
      ia.revert!
      expect(ia.file).to eq ia.file_unpublished
    end
  end
end
