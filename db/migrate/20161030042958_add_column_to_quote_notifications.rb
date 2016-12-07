class AddColumnToQuoteNotifications < ActiveRecord::Migration
  def change
    add_column(:quote_notifications, :tender_id, :integer)
  end
end
