class CreateTenderRequestQuotes < ActiveRecord::Migration
  def change
    create_table :tender_request_quotes do |t|
      t.integer :tender_id
      t.integer :sc_id
      t.integer :hc_id
      t.timestamps null: false
    end
  end
end
