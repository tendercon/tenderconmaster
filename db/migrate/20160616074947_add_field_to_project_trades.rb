class AddFieldToProjectTrades < ActiveRecord::Migration
  def up
    add_column :project_trades, :project_portfolio_id, :integer
  end
end