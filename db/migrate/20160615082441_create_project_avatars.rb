class CreateProjectAvatars < ActiveRecord::Migration
  def change
    create_table :project_avatars do |t|
      t.integer :user_id
      t.timestamps null: false
    end
  end
end