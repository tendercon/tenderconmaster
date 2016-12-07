class AddMultipleColumnsToTenderRequestQuotes < ActiveRecord::Migration
  def change
    add_column(:tender_request_quotes, :request_date, :datetime)
    add_column(:tender_request_quotes, :approved_date, :datetime)
    add_column(:tender_request_quotes, :declined_date, :datetime)
    add_column(:tender_request_quotes, :trade_id, :integer)
    add_column(:tender_request_quotes, :status, :string)
  end
end
