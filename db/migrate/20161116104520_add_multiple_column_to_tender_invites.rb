class AddMultipleColumnToTenderInvites < ActiveRecord::Migration
  def change
    add_column(:tender_invites, :user_id, :integer)
    add_column(:tender_invites, :email_sent, :datetime)
    add_column(:tender_invites, :user_seen, :boolean, :default => false)
  end
end
