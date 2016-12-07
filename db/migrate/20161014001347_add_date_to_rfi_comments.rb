class AddDateToRfiComments < ActiveRecord::Migration
  def change
    add_column(:rfi_comments, :created_at, :datetime)
    add_column(:rfi_comments, :updated_at, :datetime)
  end
end
