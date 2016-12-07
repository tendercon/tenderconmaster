class AddColumnTenderconIdToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :tendercon_id, :integer
  end
end
