# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  arcana_id  :integer          not null
#  job_code   :string(10)       not null
#  skill_type :string(20)       not null
#  name       :string(100)      not null
#  cost       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_skills_on_arcana_id  (arcana_id)
#  index_skills_on_cost       (cost)
#  index_skills_on_job_code   (job_code)
#  index_skills_on_name       (name)
#

require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
