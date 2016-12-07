class CreateUserTenders < ActiveRecord::Migration
  def change
    create_table :user_tenders do |t|
      t.integer :tender_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
