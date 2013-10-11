class CreateFeedImages < ActiveRecord::Migration
  def change
    create_table :feed_images do |t|
      t.string :image
      t.references :feed

      t.timestamps
    end
  end
end
