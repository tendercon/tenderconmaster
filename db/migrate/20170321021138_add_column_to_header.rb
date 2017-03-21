class AddColumnToHeader < ActiveRecord::Migration
  def change
    add_column(:header_navs, :user_type, :string)
  end
end
