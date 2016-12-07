class AddSeenToRfis < ActiveRecord::Migration
  def change
    add_column(:rfis, :seen, :string)
  end
end
