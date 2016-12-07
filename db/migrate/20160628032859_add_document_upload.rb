class AddDocumentUpload < ActiveRecord::Migration
  def up
    add_attachment :tender_documents, :document
  end
end
