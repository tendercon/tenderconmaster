class AddColumnToUserTable < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    add_column :users, :parent_id, :integer
  end
end