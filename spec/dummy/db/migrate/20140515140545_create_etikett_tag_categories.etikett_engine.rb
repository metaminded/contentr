# This migration comes from etikett_engine (originally 20130923110020)
class CreateEtikettTagCategories < ActiveRecord::Migration
  def change
    create_table :etikett_tag_categories do |t|
      t.string :name
      t.references :parent_category, index: true

      t.timestamps
    end

    create_table :etikett_tag_categories_tags do |t|
      t.references :tag
      t.references :tag_category
      t.timestamps
    end
  end
end
