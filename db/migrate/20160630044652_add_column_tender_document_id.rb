class AddColumnTenderDocumentId < ActiveRecord::Migration
  def change
    add_column :unzip_files, :tender_document_id, :integer
  end
end
