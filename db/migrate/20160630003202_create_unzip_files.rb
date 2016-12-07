class CreateUnzipFiles < ActiveRecord::Migration
  def change
    create_table :unzip_files do |t|
      t.string :path
      t.integer :user_id
      t.string :extension
      t.string :filename
      t.string :directory
      t.integer :file_size
      t.timestamps null: false
    end
  end
end
