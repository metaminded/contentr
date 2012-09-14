class CreateParagraphs < ActiveRecord::Migration
  def self.up
    create_table :paragraphs do |t|
      t.string 'area_name'
      t.integer 'position'
      t.string 'type'
      t.text 'data'
      t.references 'page_id'
      t.timestamps 
    end
  end

  def self.down
    drop_table :paragraphs
  end
end
