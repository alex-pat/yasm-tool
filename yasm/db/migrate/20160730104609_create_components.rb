class CreateComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :components do |t|
      t.string :kind
      t.text :content
      t.integer :order
      t.references :block, foreign_key: true

      t.timestamps
    end
  end
end
