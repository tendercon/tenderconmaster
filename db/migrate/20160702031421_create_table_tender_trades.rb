class CreateTableTenderTrades < ActiveRecord::Migration
  def change
    create_table :tender_trades do |t|
      t.integer :trade_id
      t.integer :tender_id
      t.timestamps null: false
    end
  end
end
