class AddAncestryToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :ancestry, :string
    add_index :nodes, :ancestry    
  end

  def self.down
    remove_column :nodes, :type
    remove_index :nodes, :ancestry
  end
end
