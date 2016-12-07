class AddAmountToUserPlan < ActiveRecord::Migration
  def change
    add_column :user_plans, :amount, :decimal, :precision => 5, :scale => 2
    add_column :user_plans, :role_type, :string
  end
end
