class CreateTenderApprovedTrades < ActiveRecord::Migration
  def change
    create_table :tender_approved_trades do |t|
      t.integer :tender_id
      t.integer :sc_id
      t.integer :hc_id
      t.integer :trade_id
      t.timestamps null: false
    end
  end
end
