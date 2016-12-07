class AddColumnTenderIdQuoteDocumens < ActiveRecord::Migration
  def change
    add_column(:quote_document_optionals, :tender_id, :integer)
    add_column(:quote_documents, :tender_id, :integer)
  end
end
