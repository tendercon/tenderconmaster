class AddActionTypeToUserSubscriptionsAndCardNumber < ActiveRecord::Migration
  def change
    add_column :user_subscriptions, :action_type, :string
    add_column :user_subscriptions, :card_number, :string
  end
end
