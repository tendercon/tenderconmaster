class CreateTableTradeCategories < ActiveRecord::Migration
  def change
    create_table :table_trade_categories do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
