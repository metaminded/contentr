# This migration comes from etikett_engine (originally 20130923131303)
class CreateEtikettTagMappings < ActiveRecord::Migration
  def change
    create_table :etikett_tag_mappings do |t|
      t.references :taggable, polymorphic: true
      t.references :tag, index: true
      t.string :type
      t.string :typ
      t.timestamps
    end
  end
end
