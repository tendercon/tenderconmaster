class RenameTradeColumn < ActiveRecord::Migration
  def change
    rename_column :trades, :category_id, :trade_category_id
  end
end
