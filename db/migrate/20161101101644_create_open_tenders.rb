class CreateOpenTenders < ActiveRecord::Migration
  def change
    create_table :open_tenders do |t|
      t.integer :tender_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
