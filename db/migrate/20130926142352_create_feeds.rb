class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.string :description
      t.string :body
      t.references :site

      t.timestamps
    end
  end
end
