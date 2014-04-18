class AddRsskeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rsskey, :string
  end
end
