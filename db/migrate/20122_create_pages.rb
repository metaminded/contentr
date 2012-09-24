class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string 'name'
      t.string 'slug'
      t.string 'url_path'
      t.integer 'position'
      t.boolean 'menu_only'
      t.string 'type'
      t.string 'ancestry'
      t.string 'description'
      t.string 'menu_title'
      t.boolean 'published', default: false
      t.boolean 'hidden', default: false
      t.string 'layout', default: "application"
      t.string 'template', default: "default"
      t.string 'linked_to'
      t.timestamps 
    end
    add_index :pages, :ancestry
    add_index :pages, :published
    add_index :pages, :hidden
  end

  def self.down
    drop_table :pages
  end
end
