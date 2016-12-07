class CreatePositionTable < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :title
      t.integer :user_id
      t.integer :parent_id
      t.timestamps null: false
    end
  end
end