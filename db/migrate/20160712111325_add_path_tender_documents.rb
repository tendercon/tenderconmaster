class AddPathTenderDocuments < ActiveRecord::Migration
  def change
    add_column :tender_documents, :document_path,  :text
  end
end
