class AddShownUsers < ActiveRecord::Migration
  def change
    add_column :users, :shown, :boolean, :default => false
  end
end
