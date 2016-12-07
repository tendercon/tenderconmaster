class ChangeTenderconIdToTenders < ActiveRecord::Migration
  def change
    change_column :tenders, :tendercon_id, :string
  end
end
