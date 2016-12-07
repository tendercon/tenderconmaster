class AddColumnToRfiHcId < ActiveRecord::Migration
  def change
    add_column :rfis, :hc_id,  :integer
  end
end
