# == Schema Information
#
# Table name: skill_effects
#
#  id              :bigint(8)        not null, primary key
#  skill_id        :integer          not null
#  order           :integer          not null
#  category        :string(100)      not null
#  subcategory     :string(100)      not null
#  multi_type      :string(100)
#  multi_condition :string(100)
#  subeffect1      :string(100)
#  subeffect2      :string(100)
#  subeffect3      :string(100)
#  subeffect4      :string(100)
#  subeffect5      :string(100)
#  note            :string(100)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_skill_effects_on_category                  (category)
#  index_skill_effects_on_category_and_subcategory  (category,subcategory)
#  index_skill_effects_on_skill_id                  (skill_id)
#  index_skill_effects_on_subeffect1                (subeffect1)
#  index_skill_effects_on_subeffect2                (subeffect2)
#  index_skill_effects_on_subeffect3                (subeffect3)
#  index_skill_effects_on_subeffect4                (subeffect4)
#  index_skill_effects_on_subeffect5                (subeffect5)
#

require 'test_helper'

class SkillEffectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
