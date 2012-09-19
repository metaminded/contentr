# This migration comes from contentr_engine (originally 20121)
class CreateFiles < ActiveRecord::Migration
  def self.up
    create_table :files do |t|
      t.string 'description'
      t.string 'slug'
      t.string 'file'
      t.timestamps 
    end
  end

  def self.down
    drop_table :files
  end
end
