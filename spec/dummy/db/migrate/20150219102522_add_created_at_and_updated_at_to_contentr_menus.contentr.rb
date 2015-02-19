# This migration comes from contentr (originally 20144)
class AddCreatedAtAndUpdatedAtToContentrMenus < ActiveRecord::Migration
  def change
    change_table :contentr_menus do |t|
      t.timestamps
    end
  end
end