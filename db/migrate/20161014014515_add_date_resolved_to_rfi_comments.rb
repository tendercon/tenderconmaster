class AddDateResolvedToRfiComments < ActiveRecord::Migration
  def change
    add_column(:rfi_comments, :date_resolved, :datetime)
  end
end
