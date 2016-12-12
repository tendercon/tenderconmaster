class AddStatusUpdatedTender < ActiveRecord::Migration
  def change
    add_column(:tenders, :status_updated, :string)
  end
end
