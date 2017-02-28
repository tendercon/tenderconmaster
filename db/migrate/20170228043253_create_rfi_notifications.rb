class CreateRfiNotifications < ActiveRecord::Migration
  def change
    create_table :rfi_notifications do |t|
      t.integer :sc_id
      t.integer :hc_id
      t.integer :rfi_id
      t.integer :tender_id
      t.string  :message
      t.string  :status
      t.timestamps null: false
    end
  end
end
