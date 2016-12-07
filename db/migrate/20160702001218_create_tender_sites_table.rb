class CreateTenderSitesTable < ActiveRecord::Migration
  def change
    create_table :tender_sites do |t|
      t.string :site_date
      t.string :site_description
      t.integer :tender_id
      t.timestamps null: false
    end
  end
end
