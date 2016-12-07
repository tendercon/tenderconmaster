class CreateTenderQoutesTable < ActiveRecord::Migration
  def change
    create_table :tender_quotes do |t|
      t.string :quote_date
      t.string :quote_description
      t.integer :tender_id
      t.timestamps null: false
    end
  end
end
