class AddStatusToAddendas < ActiveRecord::Migration
  def change
    add_column(:addendas, :status, :string)
  end
end
