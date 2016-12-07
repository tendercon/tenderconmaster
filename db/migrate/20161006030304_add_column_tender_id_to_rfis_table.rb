class AddColumnTenderIdToRfisTable < ActiveRecord::Migration
  def change
    add_column :rfi_documents, :tender_id,  :integer
  end
end
