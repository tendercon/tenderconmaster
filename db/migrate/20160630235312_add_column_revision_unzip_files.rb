class AddColumnRevisionUnzipFiles < ActiveRecord::Migration
  def change
    add_column :unzip_files, :revision, :string
  end
end
