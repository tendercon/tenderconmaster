class AddColumnToUserSubscriptions < ActiveRecord::Migration

  def change
    add_column :user_subscriptions, :notify1, :boolean, :default => false
    add_column :user_subscriptions, :notify2, :boolean, :default => false
    add_column :user_subscriptions, :notify3, :boolean, :default => false
    add_column :user_subscriptions, :notify4, :boolean, :default => false
    add_column :user_subscriptions, :lightbox1, :boolean, :default => false
    add_column :user_subscriptions, :lightbox2, :boolean, :default => false
    add_column :user_subscriptions, :lightbox3, :boolean, :default => false
    add_column :user_subscriptions, :lightbox4, :boolean, :default => false
    add_column :user_subscriptions, :lightbox5, :boolean, :default => false
  end
end