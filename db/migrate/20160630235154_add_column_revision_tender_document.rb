class AddColumnRevisionTenderDocument < ActiveRecord::Migration
  def change
    add_column :tender_documents, :revision, :string
  end
end
