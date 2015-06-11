FactoryGirl.define do
  factory :image_asset, class: 'Contentr::ImageAsset' do |ia|
    ia.file  { 'dhh.jpg' }
    ia.file_unpublished { 'tenderlove.png' }
  end
end
