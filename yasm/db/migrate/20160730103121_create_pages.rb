class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :layout
      t.string :url
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end
