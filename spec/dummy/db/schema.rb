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

ActiveRecord::Schema.define(version: 20151107161200) do

  create_table "alcms_blocks", force: :cascade do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.datetime "starts_at_draft"
    t.datetime "expires_at_draft"
    t.integer  "origin_block_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "alcms_blocks", ["name"], name: "index_alcms_blocks_on_name"

  create_table "alcms_texts", force: :cascade do |t|
    t.integer  "block_id"
    t.string   "name"
    t.text     "content"
    t.text     "content_draft"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "alcms_texts", ["block_id"], name: "index_alcms_texts_on_block_id"
  add_index "alcms_texts", ["name"], name: "index_alcms_texts_on_name"

end
