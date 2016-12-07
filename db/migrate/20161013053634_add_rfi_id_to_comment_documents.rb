class AddRfiIdToCommentDocuments < ActiveRecord::Migration
  def change
    add_column :comment_documents, :rfi_id,  :integer
    add_column :comment_documents, :sc_id,  :integer
    add_column :comment_documents, :hc_id,  :integer
    add_column :comment_documents, :tender_id,  :integer
  end
end
