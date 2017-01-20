# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  rsskey                 :string(255)
#  time_zone              :string           default("Moscow"), not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :sites, dependent: :destroy
  has_many :feeds, through: :sites
  has_many :favorits, dependent: :destroy

  # def time_zone
  #   unless @time_zone
  #     tz_id = read_attribute(:time_zone)
  #     as_name = ActiveSupport::TimeZone::MAPPING.select do |_,v|
  #       v == tz_id
  #     end.sort_by do |k,v|
  #       v.ends_with?(k) ? 0 : 1
  #     end.first.try(:first)
  #     value = as_name || tz_id
  #     @time_zone = value && ActiveSupport::TimeZone[value]
  #   end
  #   @time_zone
  # end
  #
  # def time_zone=(value)
  #   tz_id = value.respond_to?(:tzinfo) && value.tzinfo.name || nil
  #   tz_id ||= TZInfo.Timezone.get(ActiveSupport::TimeZone::MAPPING[value.to_s] || value.to_s).indentifier rescue nil
  #   @time_zone = tz_id && ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(tz_id) || tz_id]
  #   write_attribute(:time_zone, tz_id)
  # end
end
