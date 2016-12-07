class AddSenderToRfiComments < ActiveRecord::Migration
  def change
    add_column(:rfi_comments, :sender, :integer)
  end
end
