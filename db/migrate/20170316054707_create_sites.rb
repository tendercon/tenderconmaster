class CreateCms < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string  :page
      t.string  :title
      t.timestamps null: false
    end
  end
end
