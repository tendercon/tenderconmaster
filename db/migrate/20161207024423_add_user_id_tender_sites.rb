class AddUserIdTenderSites < ActiveRecord::Migration
  def change
    add_column(:tender_sites, :user_id, :integer)
  end
end
