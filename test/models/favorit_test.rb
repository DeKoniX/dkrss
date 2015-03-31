# == Schema Information
#
# Table name: favorits
#
#  id          :integer          not null, primary key
#  url         :string(255)      not null
#  name        :string(255)      not null
#  body        :text
#  description :text
#  link        :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  slug        :string(255)
#

require 'test_helper'

class FavoritTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
