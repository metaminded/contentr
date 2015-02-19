class CreateContentrAlternativeLink < ActiveRecord::Migration
  def change
    create_table :contentr_alternative_links do |t|
      t.string :language
      t.references :page, index: true
      t.references :nav_point, index: true
    end
  end
end
