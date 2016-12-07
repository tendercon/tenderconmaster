class AddColumnQuoteDocuments < ActiveRecord::Migration
  def change
    add_attachment :quote_documents, :document
    add_attachment :quote_document_optionals, :document
  end
end
