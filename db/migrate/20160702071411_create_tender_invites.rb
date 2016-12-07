class CreateTenderInvites < ActiveRecord::Migration
  def change
    create_table :tender_invites do |t|
      t.integer :trade_id
      t.integer :tender_id
      t.string  :name
      t.string  :email
      t.string  :status
      t.timestamps null: false
    end
  end
end
