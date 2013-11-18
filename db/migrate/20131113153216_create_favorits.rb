class CreateFavorits < ActiveRecord::Migration
  def change
    create_table :favorits do |t|
      t.string :url, null: false
      t.string :name, null: false
      t.text :body
      t.text :description
      t.boolean :link, default: false

      t.timestamps
    end
  end
end
