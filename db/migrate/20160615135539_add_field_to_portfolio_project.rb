class AddFieldToPortfolioProject < ActiveRecord::Migration
  def up
    add_column :project_portfolios, :category_id, :integer
  end
end