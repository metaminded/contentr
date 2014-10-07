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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140502102250) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contentr_content_blocks", force: true do |t|
    t.string   "name"
    t.string   "partial"
    t.string   "visible",    default: "t"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contentr_files", force: true do |t|
    t.string   "description"
    t.string   "slug"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contentr_image_assets", force: true do |t|
    t.string   "file"
    t.string   "file_unpublished"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contentr_nav_points", force: true do |t|
    t.integer  "page_id"
    t.integer  "site_id"
    t.string   "title"
    t.string   "ancestry"
    t.string   "url"
    t.integer  "parent_page_id"
    t.integer  "position",       default: 0
    t.string   "type"
    t.text     "payload"
    t.boolean  "removable",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contentr_nav_points", ["ancestry"], name: "index_contentr_nav_points_on_ancestry"

  create_table "contentr_page_types", force: true do |t|
    t.string  "name"
    t.string  "sid"
    t.integer "header_offset",             default: 0
    t.integer "col1_offset",               default: 0
    t.integer "col2_offset",               default: 0
    t.integer "col3_offset",               default: 0
    t.integer "col1_width"
    t.integer "col2_width"
    t.integer "col3_width"
    t.text    "header_allowed_paragraphs", default: "*"
    t.text    "col1_allowed_paragraphs",   default: "*"
    t.text    "col2_allowed_paragraphs",   default: "*"
    t.text    "col3_allowed_paragraphs",   default: "*"
  end

  create_table "contentr_pages", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.string   "menu_title"
    t.boolean  "published",                   default: false
    t.string   "layout",                      default: "application"
    t.string   "linked_to"
    t.string   "ancestry"
    t.string   "url_path"
    t.string   "language"
    t.boolean  "removable",                   default: true
    t.integer  "page_in_default_language_id"
    t.integer  "page_type_id"
    t.integer  "displayable_id"
    t.string   "displayable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contentr_pages", ["ancestry"], name: "index_contentr_pages_on_ancestry"
  add_index "contentr_pages", ["published"], name: "index_contentr_pages_on_published"

  create_table "contentr_paragraphs", force: true do |t|
    t.string   "area_name"
    t.integer  "position",                    default: 0
    t.string   "type"
    t.text     "data"
    t.text     "unpublished_data"
    t.boolean  "visible",                     default: false
    t.integer  "page_id"
    t.integer  "content_block_id"
    t.integer  "content_block_to_display_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
