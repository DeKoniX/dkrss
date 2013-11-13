class AddUserRefToSites < ActiveRecord::Migration
  def change
    add_reference :sites, :user, index: true
  end
end
