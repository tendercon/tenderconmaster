class AddColumnToTenderPublish < ActiveRecord::Migration
  def change
    add_column :tenders, :publish,  :boolean, :default => false
  end
end
