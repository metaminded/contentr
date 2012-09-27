class CreateImageAssets < ActiveRecord::Migration
  def self.up
    create_table :image_assets do |t|
      t.string 'file'
      t.string 'file_unpublished'
      t.string 'type'
      t.timestamps 
    end
  end

  def self.down
    drop_table :image_assets
  end
end
