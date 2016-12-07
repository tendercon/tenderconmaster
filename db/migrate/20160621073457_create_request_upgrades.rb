class CreateRequestUpgrades < ActiveRecord::Migration
  def change
    create_table :request_upgrades do |t|
      t.string :plan
      t.integer :user_id
      t.integer :plan_id
      t.timestamps null: false
    end
  end
end
