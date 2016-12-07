class AddColumnToCommentDocuments < ActiveRecord::Migration
  def change
    add_column :comment_documents, :str_token,  :string
  end
end
