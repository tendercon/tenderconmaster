class RenameColumnToInvitedTenderNotifications < ActiveRecord::Migration
  def change
    rename_column :invited_tender_notifications, :tender_request_quote_id, :tender_invite_id
  end
end
