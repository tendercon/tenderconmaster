class CreateCompanyAvatar < ActiveRecord::Migration
  def change
    create_table :company_avatar do |t|
      t.integer :user_id
      t.timestamps null: false
    end
  end
end