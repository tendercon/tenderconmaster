class RenameTradeCategories < ActiveRecord::Migration
  def change
    rename_table :table_trade_categories, :trade_categories
  end
end
