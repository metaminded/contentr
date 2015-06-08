# This migration comes from contentr (originally 20153)
class AddTemplateToContentrPages < ActiveRecord::Migration
  def change
    change_table :contentr_pages do |t|
      t.string :template
    end
  end
end
