# == Schema Information
#
# Table name: illustrators
#
#  id         :bigint(8)        not null, primary key
#  name       :string(100)      not null
#  count      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_illustrators_on_name  (name) UNIQUE
#

require 'test_helper'

class IllustratorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
