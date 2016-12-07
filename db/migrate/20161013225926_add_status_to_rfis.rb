class AddStatusToRfis < ActiveRecord::Migration
  def change
    add_column :rfis, :status,  :string
  end
end
