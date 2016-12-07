class AddExpiryDate < ActiveRecord::Migration
  def change
    add_column :user_subscriptions, :expiry_date, :date
  end
end