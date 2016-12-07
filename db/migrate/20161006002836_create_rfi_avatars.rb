class CreateRfiAvatars < ActiveRecord::Migration
  def change
    create_table :rfi_documents do |t|
      t.integer :user_id
      t.integer :rfi_id
      t.timestamps null: false
    end
  end
end
