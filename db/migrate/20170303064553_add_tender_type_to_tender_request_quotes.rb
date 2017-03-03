class AddTenderTypeToTenderRequestQuotes < ActiveRecord::Migration
  def change
    add_column(:tender_request_quotes, :tender_type, :string)
  end
end
