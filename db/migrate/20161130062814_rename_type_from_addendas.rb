class RenameTypeFromAddendas < ActiveRecord::Migration
  def change
    rename_column :addendas, :type, :addenda_type
  end
end
