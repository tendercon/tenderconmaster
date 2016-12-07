class AddDateResolvedToRfis < ActiveRecord::Migration
  def change
    add_column(:rfis, :date_resolved, :datetime)
  end
end
