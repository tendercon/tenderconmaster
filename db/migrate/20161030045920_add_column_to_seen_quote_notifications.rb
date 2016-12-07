class AddColumnToSeenQuoteNotifications < ActiveRecord::Migration
  def change
    add_column(:quote_notifications, :seen, :integer)
  end
end
