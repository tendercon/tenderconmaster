class AddCompanyTenderInvites < ActiveRecord::Migration
  def change
    add_column(:tender_invites, :company, :string)
  end
end
