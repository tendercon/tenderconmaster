class ChangeAboutMe < ActiveRecord::Migration

  def change
    change_column :user_infos, :about_me, :text
  end

end