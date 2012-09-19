# This migration comes from contentr_engine (originally 20125)
class AddPageToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :description, :string
    add_column :nodes, :menu_title, :string
    add_column :nodes, :published, :boolean, default: false
    add_column :nodes, :hidden, :boolean, default:false
    add_index :nodes, :published
    add_index :nodes, :hidden
  end

  def self.down
    remove_column :nodes, :description
    remove_column :nodes, :menu_title
    remove_column :nodes, :published
    remove_column :nodes, :hidden    
    remove_index :nodes, :published
    remove_index :nodes, :hidden
  end
end
