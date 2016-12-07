class AddColumnUserIdQuoteDocumens < ActiveRecord::Migration
  def change
    add_column(:quote_document_optionals, :user_id, :integer)
    add_column(:quote_documents, :user_id, :integer)
  end
end
