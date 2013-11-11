class AddDateToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :date, :datetime
  end
end
