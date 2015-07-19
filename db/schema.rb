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

ActiveRecord::Schema.define(version: 20150714023444) do

  create_table "abilities", force: :cascade do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "explanation", limit: 500
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "abilities", ["name"], name: "index_abilities_on_name", unique: true, using: :btree

  create_table "ability_effects", force: :cascade do |t|
    t.integer  "ability_id", limit: 4,                null: false
    t.integer  "order",      limit: 4,                null: false
    t.string   "category",   limit: 100,              null: false
    t.string   "condition",  limit: 100,              null: false
    t.string   "effect",     limit: 100,              null: false
    t.string   "target",     limit: 100,              null: false
    t.string   "note",       limit: 300, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "ability_effects", ["ability_id"], name: "index_ability_effects_on_ability_id", using: :btree
  add_index "ability_effects", ["category", "condition"], name: "index_ability_effects_on_category_and_condition", using: :btree
  add_index "ability_effects", ["category", "effect"], name: "index_ability_effects_on_category_and_effect", using: :btree
  add_index "ability_effects", ["category"], name: "index_ability_effects_on_category", using: :btree
  add_index "ability_effects", ["condition", "effect"], name: "index_ability_effects_on_condition_and_effect", using: :btree
  add_index "ability_effects", ["condition"], name: "index_ability_effects_on_condition", using: :btree
  add_index "ability_effects", ["effect"], name: "index_ability_effects_on_effect", using: :btree
  add_index "ability_effects", ["target"], name: "index_ability_effects_on_target", using: :btree

  create_table "arcanas", force: :cascade do |t|
    t.string   "name",              limit: 100,             null: false
    t.string   "title",             limit: 200
    t.integer  "rarity",            limit: 3,               null: false
    t.integer  "cost",              limit: 4,               null: false
    t.string   "weapon_type",       limit: 10,              null: false
    t.string   "job_type",          limit: 10,              null: false
    t.integer  "job_index",         limit: 4,               null: false
    t.string   "job_code",          limit: 20,              null: false
    t.string   "job_detail",        limit: 50
    t.string   "source_category",   limit: 100,             null: false
    t.string   "source",            limit: 100,             null: false
    t.string   "union",             limit: 100,             null: false
    t.integer  "max_atk",           limit: 8
    t.integer  "max_hp",            limit: 8
    t.integer  "limit_atk",         limit: 8
    t.integer  "limit_hp",          limit: 8
    t.integer  "skill_id",          limit: 4,   default: 0, null: false
    t.integer  "first_ability_id",  limit: 4,   default: 0, null: false
    t.integer  "second_ability_id", limit: 4,   default: 0, null: false
    t.integer  "chain_ability_id",  limit: 4,   default: 0, null: false
    t.integer  "chain_cost",        limit: 4,   default: 0, null: false
    t.integer  "voice_actor_id",    limit: 4,   default: 0, null: false
    t.integer  "illustrator_id",    limit: 4,   default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "arcanas", ["chain_ability_id"], name: "index_arcanas_on_chain_ability_id", using: :btree
  add_index "arcanas", ["chain_cost"], name: "index_arcanas_on_chain_cost", using: :btree
  add_index "arcanas", ["cost"], name: "index_arcanas_on_cost", using: :btree
  add_index "arcanas", ["first_ability_id"], name: "index_arcanas_on_first_ability_id", using: :btree
  add_index "arcanas", ["illustrator_id"], name: "index_arcanas_on_illustrator_id", using: :btree
  add_index "arcanas", ["job_code"], name: "index_arcanas_on_job_code", unique: true, using: :btree
  add_index "arcanas", ["job_type", "job_index"], name: "index_arcanas_on_job_type_and_job_index", using: :btree
  add_index "arcanas", ["job_type", "rarity", "job_index"], name: "index_arcanas_on_job_type_and_rarity_and_job_index", using: :btree
  add_index "arcanas", ["job_type", "rarity"], name: "index_arcanas_on_job_type_and_rarity", using: :btree
  add_index "arcanas", ["job_type"], name: "index_arcanas_on_job_type", using: :btree
  add_index "arcanas", ["limit_atk"], name: "index_arcanas_on_limit_atk", using: :btree
  add_index "arcanas", ["limit_hp"], name: "index_arcanas_on_limit_hp", using: :btree
  add_index "arcanas", ["max_atk"], name: "index_arcanas_on_max_atk", using: :btree
  add_index "arcanas", ["max_hp"], name: "index_arcanas_on_max_hp", using: :btree
  add_index "arcanas", ["name"], name: "index_arcanas_on_name", using: :btree
  add_index "arcanas", ["rarity", "weapon_type"], name: "index_arcanas_on_rarity_and_weapon_type", using: :btree
  add_index "arcanas", ["rarity"], name: "index_arcanas_on_rarity", using: :btree
  add_index "arcanas", ["second_ability_id"], name: "index_arcanas_on_second_ability_id", using: :btree
  add_index "arcanas", ["skill_id"], name: "index_arcanas_on_skill_id", using: :btree
  add_index "arcanas", ["source"], name: "index_arcanas_on_source", using: :btree
  add_index "arcanas", ["source_category", "source"], name: "index_arcanas_on_source_category_and_source", using: :btree
  add_index "arcanas", ["source_category"], name: "index_arcanas_on_source_category", using: :btree
  add_index "arcanas", ["union"], name: "index_arcanas_on_union", using: :btree
  add_index "arcanas", ["voice_actor_id"], name: "index_arcanas_on_voice_actor_id", using: :btree
  add_index "arcanas", ["weapon_type"], name: "index_arcanas_on_weapon_type", using: :btree

  create_table "chain_abilities", force: :cascade do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "explanation", limit: 500
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "chain_abilities", ["name"], name: "index_chain_abilities_on_name", unique: true, using: :btree

  create_table "chain_ability_effects", force: :cascade do |t|
    t.integer  "chain_ability_id", limit: 4,                null: false
    t.integer  "order",            limit: 4,                null: false
    t.string   "category",         limit: 100,              null: false
    t.string   "condition",        limit: 100,              null: false
    t.string   "effect",           limit: 100,              null: false
    t.string   "target",           limit: 100,              null: false
    t.string   "note",             limit: 300, default: ""
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "chain_ability_effects", ["category", "condition"], name: "index_chain_ability_effects_on_category_and_condition", using: :btree
  add_index "chain_ability_effects", ["category", "effect"], name: "index_chain_ability_effects_on_category_and_effect", using: :btree
  add_index "chain_ability_effects", ["category"], name: "index_chain_ability_effects_on_category", using: :btree
  add_index "chain_ability_effects", ["chain_ability_id"], name: "index_chain_ability_effects_on_chain_ability_id", using: :btree
  add_index "chain_ability_effects", ["condition", "effect"], name: "index_chain_ability_effects_on_condition_and_effect", using: :btree
  add_index "chain_ability_effects", ["condition"], name: "index_chain_ability_effects_on_condition", using: :btree
  add_index "chain_ability_effects", ["effect"], name: "index_chain_ability_effects_on_effect", using: :btree
  add_index "chain_ability_effects", ["target"], name: "index_chain_ability_effects_on_target", using: :btree

  create_table "illustrators", force: :cascade do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "count",      limit: 4,   default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "illustrators", ["name"], name: "index_illustrators_on_name", unique: true, using: :btree

  create_table "skill_effects", force: :cascade do |t|
    t.integer  "skill_id",    limit: 4,   null: false
    t.integer  "order",       limit: 4,   null: false
    t.string   "category",    limit: 100, null: false
    t.string   "subcategory", limit: 100, null: false
    t.string   "subeffect1",  limit: 100
    t.string   "subeffect2",  limit: 100
    t.string   "subeffect3",  limit: 100
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "skill_effects", ["category", "subcategory"], name: "index_skill_effects_on_category_and_subcategory", using: :btree
  add_index "skill_effects", ["category"], name: "index_skill_effects_on_category", using: :btree
  add_index "skill_effects", ["skill_id"], name: "index_skill_effects_on_skill_id", using: :btree
  add_index "skill_effects", ["subcategory"], name: "index_skill_effects_on_subcategory", using: :btree
  add_index "skill_effects", ["subeffect1"], name: "index_skill_effects_on_subeffect1", using: :btree
  add_index "skill_effects", ["subeffect2"], name: "index_skill_effects_on_subeffect2", using: :btree
  add_index "skill_effects", ["subeffect3"], name: "index_skill_effects_on_subeffect3", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "explanation", limit: 500
    t.integer  "cost",        limit: 3,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "skills", ["cost"], name: "index_skills_on_cost", using: :btree
  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "voice_actors", force: :cascade do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "count",      limit: 4,   default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "voice_actors", ["count"], name: "index_voice_actors_on_count", using: :btree
  add_index "voice_actors", ["name"], name: "index_voice_actors_on_name", unique: true, using: :btree

end
