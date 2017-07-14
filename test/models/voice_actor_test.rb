# == Schema Information
#
# Table name: voice_actors
#
#  id         :integer          not null, primary key
#  name       :string(100)      not null
#  count      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_voice_actors_on_count  (count)
#  index_voice_actors_on_name   (name) UNIQUE
#

require 'test_helper'

class VoiceActorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
