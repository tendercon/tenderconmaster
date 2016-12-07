class AddLoggedStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :logged_status,  :string
  end
end
