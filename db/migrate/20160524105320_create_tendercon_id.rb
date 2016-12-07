class CreateTenderconId < ActiveRecord::Migration
  def change
    create_table :tendercon_code do |t|
      t.string  :name
      t.timestamps null: false
    end
  end
end