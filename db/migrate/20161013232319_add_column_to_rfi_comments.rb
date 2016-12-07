class AddColumnToRfiComments < ActiveRecord::Migration
  def change
    add_column :rfi_comments, :sc_id,  :integer
    add_column :rfi_comments, :hc_id,  :integer
  end
end
