class AddStatusTenderDocuments < ActiveRecord::Migration
  def change
    add_column(:tender_documents, :status, :string)
  end
end
