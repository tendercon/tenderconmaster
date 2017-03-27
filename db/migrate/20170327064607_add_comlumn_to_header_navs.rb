class AddComlumnToHeaderNavs < ActiveRecord::Migration
  def change
    add_column :header_navs, :login_path, :text
    add_column :header_navs, :registration_path, :text
  end
end
