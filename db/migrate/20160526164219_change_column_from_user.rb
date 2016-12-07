class ChangeColumnFromUser < ActiveRecord::Migration
  def up
    rename_column :users, :postion, :position
  end
end