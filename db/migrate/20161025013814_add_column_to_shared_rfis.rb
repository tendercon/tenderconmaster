class AddColumnToSharedRfis < ActiveRecord::Migration
  def change
    add_column :shared_rfis, :shared, :string
    add_column :shared_rfis, :status, :string
  end
end
