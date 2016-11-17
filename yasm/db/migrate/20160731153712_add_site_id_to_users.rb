class AddSiteIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :site_id, :string
  end
end
