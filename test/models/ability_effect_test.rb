# == Schema Information
#
# Table name: ability_effects
#
#  id             :bigint(8)        not null, primary key
#  ability_id     :integer          not null
#  order          :integer          not null
#  category       :string(100)      not null
#  condition      :string(100)      not null
#  sub_condition  :string(100)      not null
#  condition_note :string(100)      default(""), not null
#  effect         :string(100)      not null
#  sub_effect     :string(100)      not null
#  effect_note    :string(100)      default(""), not null
#  target         :string(100)      not null
#  sub_target     :string(100)      not null
#  target_note    :string(100)      default(""), not null
#  note           :string(300)      default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  condition                            (category,condition,sub_condition)
#  effect                               (category,effect,sub_effect)
#  full                                 (category,condition,effect,target)
#  index_ability_effects_on_ability_id  (ability_id)
#  target                               (category,target,sub_target)
#

require 'test_helper'

class AbilityEffectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
