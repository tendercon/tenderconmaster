class CreateTenderRequestTrades < ActiveRecord::Migration
  def change
    create_table :tender_request_trades do |t|
      t.integer :tender_request_quote_id
      t.integer :trade_id
      t.timestamps null: false
    end
  end
end
