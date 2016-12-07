class AddColumnToTenderApprovedTrade < ActiveRecord::Migration
  def change
    add_column :tender_approved_trades, :tender_request_quote_id,  :integer
  end
end
