class AddAddendaIdToTenderDocuments < ActiveRecord::Migration
  def change
    add_column(:tender_documents, :addenda_id, :integer)
  end
end
