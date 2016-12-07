class AddToUserFacebook < ActiveRecord::Migration
  def up
    add_column :user_facebooks, :user_id, :integer
  end
end