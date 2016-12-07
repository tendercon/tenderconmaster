class AddFieldToProjectAvatar < ActiveRecord::Migration

  def up
    add_column :project_avatars, :project_portfolio_id, :integer
  end
end