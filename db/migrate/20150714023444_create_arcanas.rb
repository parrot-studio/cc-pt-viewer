class CreateArcanas < ActiveRecord::Migration
  def change
    create_table 'abilities' do |t|
      t.string   'name',        limit: 100, null: false
      t.string   'explanation', limit: 500
      t.timestamps null: false
    end

    add_index 'abilities', ['name'], unique: true

    create_table 'ability_effects' do |t|
      t.integer  'ability_id', limit: 4,                null: false
      t.integer  'order',      limit: 4,                null: false
      t.string   'category',   limit: 100,              null: false
      t.string   'condition',  limit: 100,              null: false
      t.string   'effect',     limit: 100,              null: false
      t.string   'target',     limit: 100,              null: false
      t.string   'note',       limit: 300, default: ''
      t.timestamps null: false
    end

    add_index 'ability_effects', ['ability_id']
    add_index 'ability_effects', %w(category condition)
    add_index 'ability_effects', %w(category effect)
    add_index 'ability_effects', ['category']
    add_index 'ability_effects', %w(condition effect)
    add_index 'ability_effects', ['condition']
    add_index 'ability_effects', ['effect']
    add_index 'ability_effects', ['target']

    create_table 'arcanas' do |t|
      t.string   'name',              limit: 100,             null: false
      t.string   'title',             limit: 200
      t.integer  'rarity',            limit: 3,               null: false
      t.integer  'cost',              limit: 4,               null: false
      t.string   'weapon_type',       limit: 10,              null: false
      t.string   'job_type',          limit: 10,              null: false
      t.integer  'job_index',         limit: 4,               null: false
      t.string   'job_code',          limit: 20,              null: false
      t.string   'job_detail',        limit: 50
      t.string   'source_category',   limit: 100,             null: false
      t.string   'source',            limit: 100,             null: false
      t.string   'union',             limit: 100,             null: false
      t.integer  'max_atk',           limit: 8
      t.integer  'max_hp',            limit: 8
      t.integer  'limit_atk',         limit: 8
      t.integer  'limit_hp',          limit: 8
      t.integer  'skill_id',          limit: 4,   default: 0, null: false
      t.integer  'first_ability_id',  limit: 4,   default: 0, null: false
      t.integer  'second_ability_id', limit: 4,   default: 0, null: false
      t.integer  'chain_ability_id',  limit: 4,   default: 0, null: false
      t.integer  'chain_cost',        limit: 4,   default: 0, null: false
      t.integer  'voice_actor_id',    limit: 4,   default: 0, null: false
      t.integer  'illustrator_id',    limit: 4,   default: 0, null: false
      t.timestamps null: false
    end

    add_index 'arcanas', ['chain_ability_id']
    add_index 'arcanas', ['chain_cost']
    add_index 'arcanas', ['cost']
    add_index 'arcanas', ['first_ability_id']
    add_index 'arcanas', ['illustrator_id']
    add_index 'arcanas', ['job_code'], unique: true
    add_index 'arcanas', %w(job_type job_index)
    add_index 'arcanas', %w(job_type rarity job_index)
    add_index 'arcanas', %w(job_type rarity)
    add_index 'arcanas', ['job_type']
    add_index 'arcanas', ['limit_atk']
    add_index 'arcanas', ['limit_hp']
    add_index 'arcanas', ['max_atk']
    add_index 'arcanas', ['max_hp']
    add_index 'arcanas', ['name']
    add_index 'arcanas', %w(rarity weapon_type)
    add_index 'arcanas', ['rarity']
    add_index 'arcanas', ['second_ability_id']
    add_index 'arcanas', ['skill_id']
    add_index 'arcanas', ['source']
    add_index 'arcanas', %w(source_category source)
    add_index 'arcanas', ['source_category']
    add_index 'arcanas', ['union']
    add_index 'arcanas', ['voice_actor_id']
    add_index 'arcanas', ['weapon_type']

    create_table 'chain_abilities' do |t|
      t.string   'name',        limit: 100, null: false
      t.string   'explanation', limit: 500
      t.timestamps null: false
    end

    add_index 'chain_abilities', ['name'], unique: true

    create_table 'chain_ability_effects' do |t|
      t.integer  'chain_ability_id', limit: 4,                null: false
      t.integer  'order',            limit: 4,                null: false
      t.string   'category',         limit: 100,              null: false
      t.string   'condition',        limit: 100,              null: false
      t.string   'effect',           limit: 100,              null: false
      t.string   'target',           limit: 100,              null: false
      t.string   'note',             limit: 300, default: ''
      t.timestamps null: false
    end

    add_index 'chain_ability_effects', %w(category condition)
    add_index 'chain_ability_effects', %w(category effect)
    add_index 'chain_ability_effects', ['category']
    add_index 'chain_ability_effects', ['chain_ability_id']
    add_index 'chain_ability_effects', %w(condition effect)
    add_index 'chain_ability_effects', ['condition']
    add_index 'chain_ability_effects', ['effect']
    add_index 'chain_ability_effects', ['target']

    create_table 'illustrators' do |t|
      t.string   'name',       limit: 100,             null: false
      t.integer  'count',      limit: 4,   default: 0, null: false
      t.timestamps null: false
    end

    add_index 'illustrators', ['name'], unique: true

    create_table 'skill_effects' do |t|
      t.integer  'skill_id',    limit: 4,   null: false
      t.integer  'order',       limit: 4,   null: false
      t.string   'category',    limit: 100, null: false
      t.string   'subcategory', limit: 100, null: false
      t.string   'subeffect1',  limit: 100
      t.string   'subeffect2',  limit: 100
      t.string   'subeffect3',  limit: 100
      t.timestamps null: false
    end

    add_index 'skill_effects', %w(category subcategory)
    add_index 'skill_effects', ['category']
    add_index 'skill_effects', ['skill_id']
    add_index 'skill_effects', ['subcategory']
    add_index 'skill_effects', ['subeffect1']
    add_index 'skill_effects', ['subeffect2']
    add_index 'skill_effects', ['subeffect3']

    create_table 'skills' do |t|
      t.string   'name',        limit: 100, null: false
      t.string   'explanation', limit: 500
      t.integer  'cost',        limit: 3,   null: false
      t.timestamps null: false
    end

    add_index 'skills', ['cost']
    add_index 'skills', ['name'], unique: true

    create_table 'voice_actors' do |t|
      t.string   'name',       limit: 100,             null: false
      t.integer  'count',      limit: 4,   default: 0, null: false
      t.timestamps null: false
    end

    add_index 'voice_actors', ['count']
    add_index 'voice_actors', ['name'], unique: true
  end
end
