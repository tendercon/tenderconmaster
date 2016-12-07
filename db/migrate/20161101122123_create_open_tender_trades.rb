class CreateOpenTenderTrades < ActiveRecord::Migration
  def change
    create_table :open_tender_trades do |t|
      t.integer :tender_id
      t.integer :user_id
      t.integer :trade_id
      t.timestamps null: false
    end
  end
end
