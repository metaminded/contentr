# This migration comes from contentr (originally 20132)
class CreateContentrContentBlocks < ActiveRecord::Migration
  def change
    create_table :contentr_content_blocks do |t|
      t.string :name
      t.string :partial
      t.string :visible, default: true
      t.timestamps
    end
  end
end
