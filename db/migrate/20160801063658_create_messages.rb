class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :tender_id
      t.integer :trade_id
      t.integer :sc_id
      t.integer :hc_id
      t.string  :channel
      t.string  :message
      t.timestamps null: false
    end
  end
end
