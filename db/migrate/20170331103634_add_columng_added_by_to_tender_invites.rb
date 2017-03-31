class AddColumngAddedByToTenderInvites < ActiveRecord::Migration
  def change
    add_column(:tender_invites, :added_by, :string)
    add_column(:tender_invites, :added_by_status, :string)
  end
end
