class AddTradeIdToInvitedTenderNotifications < ActiveRecord::Migration
  def change
    add_column(:invited_tender_notifications, :trade_id, :integer)
  end
end
