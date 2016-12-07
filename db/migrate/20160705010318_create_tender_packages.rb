class CreateTenderPackages < ActiveRecord::Migration
  def change
    create_table :tender_packages do |t|
      t.integer :tender_id
      t.integer :trade_id
      t.integer :category_id
      t.integer :tender_document_id
      t.string  :status
      t.timestamps null: false
    end
  end
end
