class CreateScInviteNotifications < ActiveRecord::Migration
  def change
    create_table :sc_invite_notifications do |t|
        t.integer :tender_id
        t.integer :user_id
        t.string  :message
        t.string  :user_status
        t.integer :seen
        t.timestamps null: false
    end
  end
end
