class CreateQuoteDocument < ActiveRecord::Migration
  def change
    create_table :quote_documents do |t|
      t.integer :quote_id
      t.timestamps null: false
    end

    create_table :quote_document_optionals do |t|
      t.integer :quote_id
      t.timestamps null: false
    end
  end
end
