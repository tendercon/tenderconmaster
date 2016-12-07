class AddColumnToRfisTable < ActiveRecord::Migration
  def change
      add_attachment :rfi_documents, :document
  end
end
