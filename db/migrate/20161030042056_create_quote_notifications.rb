class CreateQuoteNotifications < ActiveRecord::Migration
  def change
    create_table :quote_notifications do |t|
      t.integer :sc_id
      t.integer :hc_id
      t.integer :quote_id
      t.string   :message
      t.timestamps null: false
    end
  end
end
