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

class Feed < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :feed_images, dependent: :destroy
  belongs_to :sites
  belongs_to :users
end
