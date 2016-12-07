class AddRequestToResolveToRfis < ActiveRecord::Migration
  def change
    add_column(:rfis, :request, :integer)
  end
end
