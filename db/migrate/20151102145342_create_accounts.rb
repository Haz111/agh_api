class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :access_id
      t.string :authentication_token

      t.timestamps null: false
    end
  end
end
