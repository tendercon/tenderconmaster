class AddUserUniqeKey < ActiveRecord::Migration

  def change
    add_column :users, :unique_key, :string
    add_column :users, :logged_count, :integer
  end
end