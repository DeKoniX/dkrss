class AddSlugToFeedAndFavoritAndSite < ActiveRecord::Migration
  def change
    add_column :feeds, :slug, :string
    add_column :sites, :slug, :string
    add_column :favorits, :slug, :string

    add_index :sites, :slug, unique: true
    add_index :feeds, :slug, unique: true
    add_index :favorits, :slug, unique: true
  end
end
