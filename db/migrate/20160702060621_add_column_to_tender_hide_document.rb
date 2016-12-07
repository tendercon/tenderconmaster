class AddColumnToTenderHideDocument < ActiveRecord::Migration
  def change
    add_column :tenders, :hide_document, :string
  end
end
