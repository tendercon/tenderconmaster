class CreateInvitedTenderNotifications < ActiveRecord::Migration
  def change
    create_table :invited_tender_notifications do |t|
      t.integer :sc_id
      t.integer :hc_id
      t.integer :tender_request_quote_id
      t.integer :tender_id
      t.string  :message
      t.string  :status
      t.string  :added_by
      t.timestamps null: false
    end
  end
end
