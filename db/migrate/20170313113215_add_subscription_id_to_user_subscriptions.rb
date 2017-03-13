class AddSubscriptionIdToUserSubscriptions < ActiveRecord::Migration
  def change
    add_column(:user_subscriptions, :customer_subscription_id, :string)
  end
end
