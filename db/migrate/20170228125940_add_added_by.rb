class AddAddedBy < ActiveRecord::Migration
  def change
    add_column :rfi_notifications, :added_by, :string
  end
end
