class AddLinkedPageToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :linked_to, :string
  end

  def self.down
    remove_column :nodes, :linked_to
  end
end
