class AddColumnToProjectAvatars < ActiveRecord::Migration
  def up
    add_attachment :project_avatars, :image
  end
end