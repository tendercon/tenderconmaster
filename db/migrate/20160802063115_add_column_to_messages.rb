class AddColumnToMessages < ActiveRecord::Migration
  def change
    change_column :messages, :message, :text
    add_column :messages, :group_name,  :string
    add_column :messages, :from,  :integer
    add_column :messages, :to,  :integer
  end
end
