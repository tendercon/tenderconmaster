class AddButtonStatusUser < ActiveRecord::Migration
  def change
    add_column :users, :div_status, :boolean, default: false
  end
end