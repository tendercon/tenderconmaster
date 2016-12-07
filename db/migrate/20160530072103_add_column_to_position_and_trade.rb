class AddColumnToPositionAndTrade < ActiveRecord::Migration
  def change
    add_column :positions, :status, :integer
    add_column :trades, :status, :integer
  end
end