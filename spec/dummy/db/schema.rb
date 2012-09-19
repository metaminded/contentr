# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120918085141) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "files", :force => true do |t|
    t.string   "description"
    t.string   "slug"
    t.string   "file"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "url_path"
    t.integer  "position"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "type"
    t.string   "ancestry"
    t.string   "description"
    t.string   "menu_title"
    t.boolean  "published",   :default => false
    t.boolean  "hidden",      :default => false
    t.string   "linked_to"
    t.string   "layout",      :default => "application"
    t.string   "template",    :default => "default"
  end

  add_index "nodes", ["ancestry"], :name => "index_nodes_on_ancestry"
  add_index "nodes", ["hidden"], :name => "index_nodes_on_hidden"
  add_index "nodes", ["published"], :name => "index_nodes_on_published"

  create_table "paragraphs", :force => true do |t|
    t.string   "area_name"
    t.integer  "position"
    t.string   "type"
    t.text     "data"
    t.integer  "page_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
