# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  url         :string(255)
#  description :string(255)
#  body        :string(255)
#  site_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Feed < ActiveRecord::Base
  belongs_to :sites
end
