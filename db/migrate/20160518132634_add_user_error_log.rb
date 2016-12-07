class AddUserErrorLog < ActiveRecord::Migration

  def change
    add_column :users, :error_logs, :integer
  end
end