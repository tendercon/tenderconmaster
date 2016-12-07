class CreateLinkedinUser < ActiveRecord::Migration
  def change
    create_table :user_linkedins do |t|
      t.string      :provider
      t.string      :uid
      t.string      :name
      t.string      :email
      t.string      :oauth_token
      t.string      :oauth_expires_at
      t.timestamps
    end
  end
end