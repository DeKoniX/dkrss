class AddUserRefToFavorits < ActiveRecord::Migration
  def change
    add_reference :favorits, :user, index: true
  end
end
