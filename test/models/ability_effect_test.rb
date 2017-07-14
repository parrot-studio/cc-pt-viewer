# == Schema Information
#
# Table name: ability_effects
#
#  id         :integer          not null, primary key
#  ability_id :integer          not null
#  order      :integer          not null
#  category   :string(100)      not null
#  condition  :string(100)      not null
#  effect     :string(100)      not null
#  target     :string(100)      not null
#  note       :string(300)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ability_effects_on_ability_id                         (ability_id)
#  index_ability_effects_on_category                           (category)
#  index_ability_effects_on_category_and_condition             (category,condition)
#  index_ability_effects_on_category_and_condition_and_effect  (category,condition,effect)
#  index_ability_effects_on_category_and_effect                (category,effect)
#

require 'test_helper'

class AbilityEffectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
