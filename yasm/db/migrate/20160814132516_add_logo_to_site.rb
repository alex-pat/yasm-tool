class AddLogoToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :logo, :string
  end
end
