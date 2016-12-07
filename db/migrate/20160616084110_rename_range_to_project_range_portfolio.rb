class RenameRangeToProjectRangePortfolio < ActiveRecord::Migration
  def up
    rename_column :project_portfolios, :range, :project_range
  end
end