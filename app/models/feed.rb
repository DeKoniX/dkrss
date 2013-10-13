# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  url         :text(255)
#  description :text
#  body        :text
#  site_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Feed < ActiveRecord::Base
  has_many :feed_images
  belongs_to :sites
end
