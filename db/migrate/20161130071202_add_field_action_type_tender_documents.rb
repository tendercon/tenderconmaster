class AddFieldActionTypeTenderDocuments < ActiveRecord::Migration
  def change
    add_column(:tender_documents, :action_type, :string)
  end
end
