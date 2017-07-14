# == Schema Information
#
# Table name: abilities
#
#  id           :integer          not null, primary key
#  arcana_id    :integer          not null
#  job_code     :string(10)       not null
#  ability_type :string(20)       not null
#  name         :string(100)      not null
#  weapon_name  :string(100)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_abilities_on_arcana_id                  (arcana_id)
#  index_abilities_on_job_code                   (job_code)
#  index_abilities_on_job_code_and_ability_type  (job_code,ability_type) UNIQUE
#  index_abilities_on_name                       (name)
#

require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
