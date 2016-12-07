class AddColumnRfiRefNo < ActiveRecord::Migration
  def change
    add_column :rfi_documents, :rfi_ref_no,  :string
  end
end
