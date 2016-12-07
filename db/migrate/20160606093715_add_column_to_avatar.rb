class AddColumnToAvatar < ActiveRecord::Migration
  def up
    add_attachment :avatar, :image
  end
end