class CreatePrimaryTrade < ActiveRecord::Migration
  def change
    create_table :primary_trades do |t|
      t.integer :trade_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end