# == Schema Information
#
# Table name: feed_images
#
#  id         :integer          not null, primary key
#  image      :text
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class FeedImage < ActiveRecord::Base
  belongs_to :feeds
  mount_uploader :image, ImageFeedUploader
end
