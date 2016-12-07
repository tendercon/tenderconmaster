class AddFieldToUsers < ActiveRecord::Migration
  def up
    add_column :users, :role_type, :string
    add_column :users, :email_acceptance, :boolean, :default => false
  end
end