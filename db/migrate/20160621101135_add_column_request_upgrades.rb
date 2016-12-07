class AddColumnRequestUpgrades < ActiveRecord::Migration
  def change
    add_column :request_upgrades, :status, :string, :default => 'pending'
  end
end
