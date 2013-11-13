# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Site < ActiveRecord::Base
  has_many :feeds
  belongs_to :users
end
