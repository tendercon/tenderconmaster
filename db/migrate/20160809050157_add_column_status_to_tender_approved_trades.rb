class AddColumnStatusToTenderApprovedTrades < ActiveRecord::Migration
  def change
    add_column :tender_approved_trades, :status,  :string
  end
end
