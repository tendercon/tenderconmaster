class AddAbnToUser < ActiveRecord::Migration
  def change
    add_column :users, :abn, :string
    add_column :users, :tendercon_id, :string
  end
end