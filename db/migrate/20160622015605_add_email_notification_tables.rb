class AddEmailNotificationTables < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.integer :user_id
      t.string :description
      t.string :status
      t.timestamps null: false
    end
  end
end
