class TenderDocuments < ActiveRecord::Migration
  def change
    create_table :tender_documents do |t|
      t.integer :user_id
      t.integer :tender_id
      t.timestamps null: false
    end
  end
end
