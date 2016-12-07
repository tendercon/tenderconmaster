class AddTenderDocumentColumn < ActiveRecord::Migration
  def change
    add_column :tender_documents, :directory, :string
  end
end
