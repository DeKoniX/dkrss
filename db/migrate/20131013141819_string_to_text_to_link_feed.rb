class StringToTextToLinkFeed < ActiveRecord::Migration
  def up
    change_column :feeds, :url, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
