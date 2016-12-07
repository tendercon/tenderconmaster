class CreateMessageChats < ActiveRecord::Migration
  def change
    create_table :message_chats do |t|
      t.integer :tender_id
      t.integer :trade_id
      t.integer :to_id
      t.integer :from_id
      t.text  :message
      t.string :group_name
      t.timestamps null: false
    end
  end
end
