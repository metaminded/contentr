# This migration comes from contentr (originally 20141)
class CreateContentrMenu < ActiveRecord::Migration
  def change
    create_table :contentr_menus do |t|
      t.string :name
      t.string :sid
    end

    change_table :contentr_nav_points do |t|
      t.references :menu
      t.string :nav_point_type
    end
  end
end
