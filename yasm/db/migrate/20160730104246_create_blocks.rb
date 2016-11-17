class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.string :position
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
