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

ActiveRecord::Schema.define(version: 20140708053449) do

  create_table "arcanas", force: true do |t|
    t.string   "name",           limit: 100, null: false
    t.string   "title",          limit: 200
    t.integer  "rarity",         limit: 3,   null: false
    t.integer  "cost",                       null: false
    t.string   "weapon_type",    limit: 10,  null: false
    t.string   "hometown",       limit: 100, null: false
    t.string   "job_type",       limit: 10,  null: false
    t.integer  "job_index",                  null: false
    t.string   "job_code",       limit: 20,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",         limit: 100, null: false
    t.integer  "voice_actor_id",             null: false
    t.integer  "illustrator_id",             null: false
  end

  add_index "arcanas", ["cost"], name: "index_arcanas_on_cost", using: :btree
  add_index "arcanas", ["hometown", "rarity"], name: "index_arcanas_on_hometown_and_rarity", using: :btree
  add_index "arcanas", ["hometown"], name: "index_arcanas_on_hometown", using: :btree
  add_index "arcanas", ["illustrator_id"], name: "index_arcanas_on_illustrator_id", using: :btree
  add_index "arcanas", ["job_code"], name: "index_arcanas_on_job_code", unique: true, using: :btree
  add_index "arcanas", ["job_type", "hometown"], name: "index_arcanas_on_job_type_and_hometown", using: :btree
  add_index "arcanas", ["job_type", "job_index"], name: "index_arcanas_on_job_type_and_job_index", using: :btree
  add_index "arcanas", ["job_type", "rarity", "job_index"], name: "index_arcanas_on_job_type_and_rarity_and_job_index", using: :btree
  add_index "arcanas", ["job_type", "rarity"], name: "index_arcanas_on_job_type_and_rarity", using: :btree
  add_index "arcanas", ["job_type"], name: "index_arcanas_on_job_type", using: :btree
  add_index "arcanas", ["name"], name: "index_arcanas_on_name", using: :btree
  add_index "arcanas", ["rarity", "weapon_type"], name: "index_arcanas_on_rarity_and_weapon_type", using: :btree
  add_index "arcanas", ["rarity"], name: "index_arcanas_on_rarity", using: :btree
  add_index "arcanas", ["source"], name: "index_arcanas_on_source", using: :btree
  add_index "arcanas", ["voice_actor_id"], name: "index_arcanas_on_voice_actor_id", using: :btree
  add_index "arcanas", ["weapon_type"], name: "index_arcanas_on_weapon_type", using: :btree

  create_table "illustrators", force: true do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "count",                  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "illustrators", ["name"], name: "index_illustrators_on_name", unique: true, using: :btree

  create_table "voice_actors", force: true do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "count",                  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "voice_actors", ["count"], name: "index_voice_actors_on_count", using: :btree
  add_index "voice_actors", ["name"], name: "index_voice_actors_on_name", unique: true, using: :btree

end
