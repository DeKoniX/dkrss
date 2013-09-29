class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.text :description
      t.text :body
      t.references :site

      t.timestamps
    end
  end
end
