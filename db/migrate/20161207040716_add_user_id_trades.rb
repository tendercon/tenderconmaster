class AddUserIdTrades < ActiveRecord::Migration
  def change
    add_column(:trades, :user_id, :integer)
  end
end
