class ChangeColumnDataTypesUnzipTable < ActiveRecord::Migration
  def change
    change_column :unzip_files, :path, :text
  end
end
