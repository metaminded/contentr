# This migration comes from etikett_engine (originally 20130923111046)
class CreateEtikettSearchables < ActiveRecord::Migration
  def change
    create_table :etikett_searchables do |t|
      t.integer :ref_id
      t.string :ref_type
      t.tsvector :short
      t.tsvector :fulltext

      t.timestamps
    end
  end
end
