class AddStatusHcInvites < ActiveRecord::Migration
  def change
    add_column(:hc_invites, :status, :string)
  end
end
