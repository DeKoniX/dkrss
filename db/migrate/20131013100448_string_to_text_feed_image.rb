class StringToTextFeedImage < ActiveRecord::Migration
  def up
    change_column :feed_images, :image, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
