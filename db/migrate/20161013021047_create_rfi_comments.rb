class CreateRfiComments < ActiveRecord::Migration
  def change
    create_table :rfi_comments do |t|
      t.integer :rfi_id
      t.string  :comment
    end
  end
end
