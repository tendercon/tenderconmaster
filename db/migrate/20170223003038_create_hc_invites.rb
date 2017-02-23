class CreateHcInvites < ActiveRecord::Migration
  def change
    create_table :hc_invites do |t|
      t.integer :hc_id
      t.integer :trade_id
      t.integer :user_id
      t.string  :email
      t.string  :company
      t.string  :name
      t.timestamps null: false
    end
  end
end
