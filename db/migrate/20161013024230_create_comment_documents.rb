class CreateCommentDocuments < ActiveRecord::Migration
  def change
    create_table :comment_documents do |t|
      t.integer :rfi_comment_id
      t.timestamps null: false
    end
  end
end
