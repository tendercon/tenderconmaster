class AddDeclinedDateTenderInvites < ActiveRecord::Migration
  def change
    add_column(:tender_invites, :tender_declined_date, :datetime)
  end
end
