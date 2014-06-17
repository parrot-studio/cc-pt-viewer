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

ActiveRecord::Schema.define(version: 20140617063043) do

  create_table "arcanas", force: true do |t|
    t.string   "name",       limit: 100, null: false
    t.string   "title",      limit: 200
    t.integer  "rarity",     limit: 3,   null: false
    t.string   "job_type",   limit: 10,  null: false
    t.integer  "job_index",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "arcanas", ["job_type", "job_index"], name: "index_arcanas_on_job_type_and_job_index", using: :btree
  add_index "arcanas", ["job_type", "rarity"], name: "index_arcanas_on_job_type_and_rarity", using: :btree
  add_index "arcanas", ["job_type"], name: "index_arcanas_on_job_type", using: :btree
  add_index "arcanas", ["name"], name: "index_arcanas_on_name", using: :btree
  add_index "arcanas", ["rarity"], name: "index_arcanas_on_rarity", using: :btree

end
