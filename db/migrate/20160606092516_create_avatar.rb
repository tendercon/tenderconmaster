class CreateAvatar < ActiveRecord::Migration
  def change
    create_table :avatar do |t|
      t.integer :user_id
      t.timestamps null: false
    end
  end
end