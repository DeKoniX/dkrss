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
#  slug       :string(255)
#  error      :boolean          default(FALSE), not null
#

class Site < ActiveRecord::Base
  extend FriendlyId

  validates :name, presence: true
  validates :url, presence: true, :format => {:with => URI.regexp}

  friendly_id :name, use: :slugged
  has_many :feeds, dependent: :destroy
  belongs_to :users
end
