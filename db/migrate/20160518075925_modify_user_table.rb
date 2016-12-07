class ModifyUserTable < ActiveRecord::Migration
  def change
    remove_column :users, :last_name
    remove_column :users, :address
    remove_column :users, :age
    remove_column :users, :gender
    remove_column :users, :date_of_birth
    remove_column :users, :contact_number
    rename_column :users, :first_name, :name
  end
end