class AddTenderconKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :tendercon_key, :string

  end
end