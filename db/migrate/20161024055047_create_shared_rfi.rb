class CreateSharedRfi < ActiveRecord::Migration
  def change
    create_table :shared_rfis do |t|
      t.integer  :rfi_id
      t.integer  :trade_id
      t.integer  :user_id
      t.timestamps null: false
    end
  end
end
