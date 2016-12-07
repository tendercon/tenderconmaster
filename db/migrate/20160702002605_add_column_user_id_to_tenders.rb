class AddColumnUserIdToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :user_id, :integer
  end
end
