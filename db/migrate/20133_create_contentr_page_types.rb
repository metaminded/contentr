class CreateContentrPageTypes < ActiveRecord::Migration
  def change
    create_table :contentr_page_types do |t|
      t.string :name
      t.string :sid
      t.integer :header_offset, default: 0
      t.integer :col1_offset, default: 0
      t.integer :col2_offset, default: 0
      t.integer :col3_offset, default: 0
      t.integer :col1_width
      t.integer :col2_width
      t.integer :col3_width
      t.text :header_allowed_paragraphs, default: '*'
      t.text :col1_allowed_paragraphs, default: '*'
      t.text :col2_allowed_paragraphs, default: '*'
      t.text :col3_allowed_paragraphs, default: '*'
    end
  end
end
