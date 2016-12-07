class CreateTenderTables < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.string  :title
      t.string  :description
      t.string  :address
      t.string  :state
      t.integer :postcode
      t.string  :job_value
      t.integer :trade_id
      t.timestamps null: false
    end
  end

end