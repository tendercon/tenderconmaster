class CreateUsersTable < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.integer :age
      t.string :password
      t.string :confirmed_password
      t.string :gender
      t.string :date_of_birth
      t.string :contact_number
      t.timestamps null: false
    end
  end
end