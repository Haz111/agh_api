class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :name
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
