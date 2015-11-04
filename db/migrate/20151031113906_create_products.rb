class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :name
      t.decimal :price
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
