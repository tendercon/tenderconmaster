class AddColumnDocumentPackages < ActiveRecord::Migration
  def change
    add_column :document_packages, :url,  :text
  end
end
