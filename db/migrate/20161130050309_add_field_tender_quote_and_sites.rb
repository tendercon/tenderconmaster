class AddFieldTenderQuoteAndSites < ActiveRecord::Migration
  def change
    add_column(:tender_quotes, :previous_date, :string)
    add_column(:tender_sites, :previous_date, :string)
  end
end
