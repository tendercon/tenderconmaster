class CreateProjectAddressTable < ActiveRecord::Migration
  def change
    create_table :project_addresses do |t|
      t.string :state
      t.string :location
      t.integer :postcode
      t.string :suburb
      t.string :timezone
      t.integer :project_portfolio_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end