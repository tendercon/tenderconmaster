class AddOpenDateTenderInvites < ActiveRecord::Migration
  def change
    add_column(:tender_invites, :tender_open_date, :datetime)
    add_column(:tender_invites, :tender_acceptance_date, :datetime)
  end
end
