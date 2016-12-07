class CreatePackageDonwloads < ActiveRecord::Migration
  def change
    create_table :package_downloads do |t|
      t.integer :tender_id
      t.integer :trade_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
