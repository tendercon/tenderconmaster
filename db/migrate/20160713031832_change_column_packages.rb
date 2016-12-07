class ChangeColumnPackages < ActiveRecord::Migration
  def change
    rename_column :packages, :document_package_id, :tender_id
  end
end
