class AddTypeToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :type, :string    
  end

  def self.down
    remove_column :nodes, :type
  end
end
