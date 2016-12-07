class AddNotificationsTables < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :description
      t.string :status
      t.timestamps null: false
    end
  end
end
