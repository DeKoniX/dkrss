class AddErrorToSites < ActiveRecord::Migration
  def change
    add_column :sites, :error, :boolean, null: false, default: false
  end
end
