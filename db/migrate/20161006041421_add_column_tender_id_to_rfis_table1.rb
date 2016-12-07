class AddColumnTenderIdToRfisTable1 < ActiveRecord::Migration
  def change
    add_column :rfis, :tender_id,  :integer
  end
end
