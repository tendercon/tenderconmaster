class CreateSubscription < ActiveRecord::Migration
  def change
    create_table :user_subscriptions do |t|
      t.integer :user_id
      t.boolean :subscribed
      t.string :stripe_id
      t.timestamps null: false
    end
  end
end