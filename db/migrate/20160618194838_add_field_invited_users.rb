class AddFieldInvitedUsers < ActiveRecord::Migration
  def up
    add_column :users, :invited, :boolean, :default => true
  end
end