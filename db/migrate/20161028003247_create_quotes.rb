class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :user_id
      t.string  :ref_no
      t.string  :to
      t.string  :attention
      t.datetime :quote_date
      t.string  :description
      t.integer :trade_id
      t.integer :tender_id
      t.float   :price
      t.string  :status
      t.timestamps null: false

    end
  end
end
