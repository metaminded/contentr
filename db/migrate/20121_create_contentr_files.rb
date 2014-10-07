class CreateContentrFiles < ActiveRecord::Migration
  def self.up
    create_table :contentr_files do |t|
      t.string 'description'
      t.string 'slug'
      t.string 'file'
      t.timestamps
    end
  end

  def self.down
    drop_table :contentr_files
  end
end
