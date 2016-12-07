class AddDocumentToCommentDocuments < ActiveRecord::Migration
  def change
    add_attachment :comment_documents, :document
  end
end
