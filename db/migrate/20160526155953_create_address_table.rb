class CreateAddressTable < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :state
      t.string :location
      t.integer :postcode
      t.string :suburb
      t.string :timezone
      t.timestamps null: false
    end
  end
end