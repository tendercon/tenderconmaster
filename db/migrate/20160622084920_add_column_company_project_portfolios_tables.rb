class AddColumnCompanyProjectPortfoliosTables < ActiveRecord::Migration
  def change
    add_column :project_portfolios, :company, :string
  end
end
