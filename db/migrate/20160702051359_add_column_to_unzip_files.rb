class AddColumnToUnzipFiles < ActiveRecord::Migration
  def change
    add_column :unzip_files, :tender_id, :integer
  end
end
