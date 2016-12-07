class AddColumnToMessageChats < ActiveRecord::Migration
  def change
    add_column :message_chats, :status,  :string
  end
end
