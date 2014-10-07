class CreateContentrImageAssets < ActiveRecord::Migration
  def self.up
    create_table :contentr_image_assets do |t|
      t.string 'file'
      t.string 'file_unpublished'
      t.string 'type'
      t.timestamps
    end
  end

  def self.down
    drop_table :contentr_image_assets
  end
end
