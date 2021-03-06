# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_05_052744) do

  create_table "abilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "arcana_id", null: false
    t.string "job_code", limit: 10, null: false
    t.string "ability_type", limit: 20, null: false
    t.string "name", limit: 100, null: false
    t.string "weapon_name", limit: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["arcana_id"], name: "index_abilities_on_arcana_id"
    t.index ["job_code", "ability_type"], name: "index_abilities_on_job_code_and_ability_type", unique: true
    t.index ["job_code"], name: "index_abilities_on_job_code"
    t.index ["name"], name: "index_abilities_on_name"
  end

  create_table "ability_effects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "ability_id", null: false
    t.integer "order", null: false
    t.string "category", limit: 100, null: false
    t.string "condition", limit: 100, null: false
    t.string "sub_condition", limit: 100, null: false
    t.string "condition_note", limit: 100, default: "", null: false
    t.string "effect", limit: 100, null: false
    t.string "sub_effect", limit: 100, null: false
    t.string "effect_note", limit: 100, default: "", null: false
    t.string "target", limit: 100, null: false
    t.string "sub_target", limit: 100, null: false
    t.string "target_note", limit: 100, default: "", null: false
    t.string "note", limit: 300, default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ability_id"], name: "index_ability_effects_on_ability_id"
    t.index ["category", "condition", "effect", "target"], name: "full"
    t.index ["category", "condition", "sub_condition"], name: "condition"
    t.index ["category", "effect", "sub_effect"], name: "effect"
    t.index ["category", "target", "sub_target"], name: "target"
  end

  create_table "arcanas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "title", limit: 100, null: false
    t.string "arcana_type", limit: 20, null: false
    t.integer "rarity", null: false
    t.integer "cost", default: 0, null: false
    t.integer "chain_cost", default: 0, null: false
    t.string "weapon_type", limit: 10, null: false
    t.string "job_type", limit: 10, null: false
    t.integer "job_index", null: false
    t.string "job_code", limit: 10, null: false
    t.string "job_detail", limit: 50
    t.string "source_category", limit: 50, null: false
    t.string "source", limit: 50, null: false
    t.string "union", limit: 20, null: false
    t.string "person_code", limit: 10, null: false
    t.string "link_code", limit: 10
    t.integer "max_atk"
    t.integer "max_hp"
    t.integer "limit_atk"
    t.integer "limit_hp"
    t.integer "voice_actor_id", default: 0, null: false
    t.integer "illustrator_id", default: 0, null: false
    t.string "wiki_name", limit: 50
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["arcana_type"], name: "index_arcanas_on_arcana_type"
    t.index ["chain_cost"], name: "index_arcanas_on_chain_cost"
    t.index ["cost"], name: "index_arcanas_on_cost"
    t.index ["illustrator_id"], name: "index_arcanas_on_illustrator_id"
    t.index ["job_code"], name: "index_arcanas_on_job_code", unique: true
    t.index ["job_type", "job_index"], name: "index_arcanas_on_job_type_and_job_index", unique: true
    t.index ["job_type", "rarity"], name: "index_arcanas_on_job_type_and_rarity"
    t.index ["job_type"], name: "index_arcanas_on_job_type"
    t.index ["name"], name: "index_arcanas_on_name"
    t.index ["person_code"], name: "index_arcanas_on_person_code"
    t.index ["rarity"], name: "index_arcanas_on_rarity"
    t.index ["source_category", "source"], name: "index_arcanas_on_source_category_and_source"
    t.index ["source_category"], name: "index_arcanas_on_source_category"
    t.index ["title"], name: "index_arcanas_on_title"
    t.index ["union", "job_type"], name: "index_arcanas_on_union_and_job_type"
    t.index ["union"], name: "index_arcanas_on_union"
    t.index ["voice_actor_id"], name: "index_arcanas_on_voice_actor_id"
    t.index ["weapon_type"], name: "index_arcanas_on_weapon_type"
  end

  create_table "illustrators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_illustrators_on_name", unique: true
  end

  create_table "skill_effects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "skill_id", null: false
    t.integer "order", null: false
    t.string "category", limit: 100, null: false
    t.string "subcategory", limit: 100, null: false
    t.string "multi_type", limit: 100
    t.string "multi_condition", limit: 100
    t.string "subeffect1", limit: 100
    t.string "subeffect2", limit: 100
    t.string "subeffect3", limit: 100
    t.string "subeffect4", limit: 100
    t.string "subeffect5", limit: 100
    t.string "note", limit: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category", "subcategory"], name: "index_skill_effects_on_category_and_subcategory"
    t.index ["category"], name: "index_skill_effects_on_category"
    t.index ["skill_id"], name: "index_skill_effects_on_skill_id"
    t.index ["subeffect1"], name: "index_skill_effects_on_subeffect1"
    t.index ["subeffect2"], name: "index_skill_effects_on_subeffect2"
    t.index ["subeffect3"], name: "index_skill_effects_on_subeffect3"
    t.index ["subeffect4"], name: "index_skill_effects_on_subeffect4"
    t.index ["subeffect5"], name: "index_skill_effects_on_subeffect5"
  end

  create_table "skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.integer "arcana_id", null: false
    t.string "job_code", limit: 10, null: false
    t.string "skill_type", limit: 20, null: false
    t.string "name", limit: 100, null: false
    t.integer "cost", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["arcana_id"], name: "index_skills_on_arcana_id"
    t.index ["cost"], name: "index_skills_on_cost"
    t.index ["job_code"], name: "index_skills_on_job_code"
    t.index ["name"], name: "index_skills_on_name"
    t.index ["skill_type"], name: "index_skills_on_skill_type"
  end

  create_table "voice_actors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["count"], name: "index_voice_actors_on_count"
    t.index ["name"], name: "index_voice_actors_on_name", unique: true
  end

end
