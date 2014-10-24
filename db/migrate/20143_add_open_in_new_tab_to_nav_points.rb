class AddOpenInNewTabToNavPoints < ActiveRecord::Migration
  def change
    change_table :contentr_nav_points do |t|
      t.boolean :open_in_new_tab
    end
  end
end