class CreateTenderValues < ActiveRecord::Migration
  def change
    create_table :tender_values do |t|
      t.string :range

      t.timestamps null: false
    end
  end
end
