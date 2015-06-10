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
#

require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  test "если сайт пуст" do
    site = Site.new
    assert site.invalid?
    assert site.errors[:url].any?
    assert site.errors[:name].any?
  end
  test "проверка url правильный url" do
    site = Site.new url: "http://ololo.ru/asd", name: "Ololo"
    assert site.valid?
  end
  test "проверка url не правильный url" do
    favorit = Favorit.new url: "asd", name: "Ololo"
    assert favorit.invalid?
    assert favorit.errors[:url].any?
  end
  # test "the truth" do
  #   assert true
  # end
end
