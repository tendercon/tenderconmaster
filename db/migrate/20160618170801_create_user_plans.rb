class CreateUserPlans < ActiveRecord::Migration

  def change
    create_table :user_plans do |t|
      t.integer :user_id
      t.string :plan
      t.integer :plan_id
      t.timestamps null: false
    end
  end
end