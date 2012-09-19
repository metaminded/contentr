# This migration comes from contentr_engine (originally 20128)
# This migration comes from contentr_engine (originally 20126)
class AddContentPageToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :layout, :string, default: "application"
    add_column :nodes, :template, :string, default: "default"
  end

  def self.down
    remove_column :nodes, :layout
    remove_column :nodes, :template
  end
end
