# == Schema Information
#
# Table name: feed_images
#
#  id         :integer          not null, primary key
#  image      :text(255)
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class FeedImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
