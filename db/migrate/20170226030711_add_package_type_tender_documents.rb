class AddPackageTypeTenderDocuments < ActiveRecord::Migration
  def change
    add_column :tender_documents, :package_type, :string
  end
end
