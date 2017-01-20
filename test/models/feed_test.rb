# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  url         :text
#  description :text
#  body        :text
#  site_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  date        :datetime
#  slug        :string(255)
#

require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
