# == Schema Information
#
# Table name: favorits
#
#  id          :integer          not null, primary key
#  url         :string(255)      not null
#  name        :string(255)      not null
#  body        :text
#  description :text
#  link        :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  slug        :string(255)
#

require 'test_helper'

class FavoritTest < ActiveSupport::TestCase
  test "если избранное пусто" do
    favorit = Favorit.new
    assert favorit.invalid?
    assert favorit.errors[:url].any?
  end
  test "проверка url правильный url" do
    favorit = Favorit.new url: "http://ololo.ru/asd"
    assert favorit.valid?
  end
  test "проверка url не правильный url" do
    favorit = Favorit.new url: "asd"
    assert favorit.invalid?
    assert favorit.errors[:url].any?
  end
  # test "the truth" do
  #   assert true
  # end
end
