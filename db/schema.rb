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

ActiveRecord::Schema.define(version: 20160507003347) do

  create_table "abilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "explanation", limit: 500
    t.string   "weapon_name", limit: 100
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["name"], name: "index_abilities_on_name", unique: true, using: :btree
  end

  create_table "ability_effects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "ability_id",                          null: false
    t.integer  "order",                               null: false
    t.string   "category",   limit: 100,              null: false
    t.string   "condition",  limit: 100,              null: false
    t.string   "effect",     limit: 100,              null: false
    t.string   "target",     limit: 100,              null: false
    t.string   "note",       limit: 300, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["ability_id"], name: "index_ability_effects_on_ability_id", using: :btree
    t.index ["category", "condition"], name: "index_ability_effects_on_category_and_condition", using: :btree
    t.index ["category", "effect"], name: "index_ability_effects_on_category_and_effect", using: :btree
    t.index ["category"], name: "index_ability_effects_on_category", using: :btree
    t.index ["condition", "effect"], name: "index_ability_effects_on_condition_and_effect", using: :btree
    t.index ["condition"], name: "index_ability_effects_on_condition", using: :btree
    t.index ["effect"], name: "index_ability_effects_on_effect", using: :btree
    t.index ["target"], name: "index_ability_effects_on_target", using: :btree
  end

  create_table "arcanas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",              limit: 100,             null: false
    t.string   "title",             limit: 200
    t.integer  "rarity",            limit: 3,               null: false
    t.integer  "cost",                                      null: false
    t.string   "weapon_type",       limit: 10,              null: false
    t.string   "job_type",          limit: 10,              null: false
    t.integer  "job_index",                                 null: false
    t.string   "job_code",          limit: 20,              null: false
    t.string   "job_detail",        limit: 50
    t.string   "source_category",   limit: 100,             null: false
    t.string   "source",            limit: 100,             null: false
    t.string   "union",             limit: 100,             null: false
    t.bigint   "max_atk"
    t.bigint   "max_hp"
    t.bigint   "limit_atk"
    t.bigint   "limit_hp"
    t.integer  "first_skill_id",                default: 0, null: false
    t.integer  "second_skill_id",               default: 0, null: false
    t.integer  "third_skill_id",                default: 0, null: false
    t.integer  "first_ability_id",              default: 0, null: false
    t.integer  "second_ability_id",             default: 0, null: false
    t.integer  "weapon_ability_id",             default: 0, null: false
    t.integer  "chain_ability_id",              default: 0, null: false
    t.integer  "chain_cost",                    default: 0, null: false
    t.integer  "voice_actor_id",                default: 0, null: false
    t.integer  "illustrator_id",                default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["chain_ability_id"], name: "index_arcanas_on_chain_ability_id", using: :btree
    t.index ["chain_cost"], name: "index_arcanas_on_chain_cost", using: :btree
    t.index ["cost"], name: "index_arcanas_on_cost", using: :btree
    t.index ["first_ability_id"], name: "index_arcanas_on_first_ability_id", using: :btree
    t.index ["first_skill_id"], name: "index_arcanas_on_first_skill_id", using: :btree
    t.index ["illustrator_id"], name: "index_arcanas_on_illustrator_id", using: :btree
    t.index ["job_code"], name: "index_arcanas_on_job_code", unique: true, using: :btree
    t.index ["job_type", "job_index"], name: "index_arcanas_on_job_type_and_job_index", using: :btree
    t.index ["job_type", "rarity", "job_index"], name: "index_arcanas_on_job_type_and_rarity_and_job_index", using: :btree
    t.index ["job_type", "rarity"], name: "index_arcanas_on_job_type_and_rarity", using: :btree
    t.index ["job_type"], name: "index_arcanas_on_job_type", using: :btree
    t.index ["limit_atk"], name: "index_arcanas_on_limit_atk", using: :btree
    t.index ["limit_hp"], name: "index_arcanas_on_limit_hp", using: :btree
    t.index ["max_atk"], name: "index_arcanas_on_max_atk", using: :btree
    t.index ["max_hp"], name: "index_arcanas_on_max_hp", using: :btree
    t.index ["name"], name: "index_arcanas_on_name", using: :btree
    t.index ["rarity", "weapon_type"], name: "index_arcanas_on_rarity_and_weapon_type", using: :btree
    t.index ["rarity"], name: "index_arcanas_on_rarity", using: :btree
    t.index ["second_ability_id"], name: "index_arcanas_on_second_ability_id", using: :btree
    t.index ["second_skill_id"], name: "index_arcanas_on_second_skill_id", using: :btree
    t.index ["source"], name: "index_arcanas_on_source", using: :btree
    t.index ["source_category", "source"], name: "index_arcanas_on_source_category_and_source", using: :btree
    t.index ["source_category"], name: "index_arcanas_on_source_category", using: :btree
    t.index ["third_skill_id"], name: "index_arcanas_on_third_skill_id", using: :btree
    t.index ["union"], name: "index_arcanas_on_union", using: :btree
    t.index ["voice_actor_id"], name: "index_arcanas_on_voice_actor_id", using: :btree
    t.index ["weapon_ability_id"], name: "index_arcanas_on_weapon_ability_id", using: :btree
    t.index ["weapon_type"], name: "index_arcanas_on_weapon_type", using: :btree
  end

  create_table "chain_abilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "explanation", limit: 500
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["name"], name: "index_chain_abilities_on_name", unique: true, using: :btree
  end

  create_table "chain_ability_effects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "chain_ability_id",                          null: false
    t.integer  "order",                                     null: false
    t.string   "category",         limit: 100,              null: false
    t.string   "condition",        limit: 100,              null: false
    t.string   "effect",           limit: 100,              null: false
    t.string   "target",           limit: 100,              null: false
    t.string   "note",             limit: 300, default: ""
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["category", "condition"], name: "index_chain_ability_effects_on_category_and_condition", using: :btree
    t.index ["category", "effect"], name: "index_chain_ability_effects_on_category_and_effect", using: :btree
    t.index ["category"], name: "index_chain_ability_effects_on_category", using: :btree
    t.index ["chain_ability_id"], name: "index_chain_ability_effects_on_chain_ability_id", using: :btree
    t.index ["condition", "effect"], name: "index_chain_ability_effects_on_condition_and_effect", using: :btree
    t.index ["condition"], name: "index_chain_ability_effects_on_condition", using: :btree
    t.index ["effect"], name: "index_chain_ability_effects_on_effect", using: :btree
    t.index ["target"], name: "index_chain_ability_effects_on_target", using: :btree
  end

  create_table "illustrators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "count",                  default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["name"], name: "index_illustrators_on_name", unique: true, using: :btree
  end

  create_table "skill_effects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "skill_id",                    null: false
    t.integer  "order",                       null: false
    t.string   "category",        limit: 100, null: false
    t.string   "subcategory",     limit: 100, null: false
    t.string   "multi_type",      limit: 100
    t.string   "multi_condition", limit: 100
    t.string   "subeffect1",      limit: 100
    t.string   "subeffect2",      limit: 100
    t.string   "subeffect3",      limit: 100
    t.string   "subeffect4",      limit: 100
    t.string   "subeffect5",      limit: 100
    t.string   "note",            limit: 100
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["category", "subcategory"], name: "index_skill_effects_on_category_and_subcategory", using: :btree
    t.index ["category"], name: "index_skill_effects_on_category", using: :btree
    t.index ["skill_id"], name: "index_skill_effects_on_skill_id", using: :btree
    t.index ["subcategory"], name: "index_skill_effects_on_subcategory", using: :btree
    t.index ["subeffect1"], name: "index_skill_effects_on_subeffect1", using: :btree
    t.index ["subeffect2"], name: "index_skill_effects_on_subeffect2", using: :btree
    t.index ["subeffect3"], name: "index_skill_effects_on_subeffect3", using: :btree
    t.index ["subeffect4"], name: "index_skill_effects_on_subeffect4", using: :btree
    t.index ["subeffect5"], name: "index_skill_effects_on_subeffect5", using: :btree
  end

  create_table "skills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",        limit: 100, null: false
    t.string   "explanation", limit: 500
    t.integer  "cost",        limit: 3,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["cost"], name: "index_skills_on_cost", using: :btree
    t.index ["name"], name: "index_skills_on_name", unique: true, using: :btree
  end

  create_table "voice_actors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "count",                  default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["count"], name: "index_voice_actors_on_count", using: :btree
    t.index ["name"], name: "index_voice_actors_on_name", unique: true, using: :btree
  end

end
