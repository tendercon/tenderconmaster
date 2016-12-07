class AddRangeToProjectPortfolios < ActiveRecord::Migration
  def up
    add_column :project_portfolios, :range, :string
  end
end