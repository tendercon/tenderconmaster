class CreateProjectPortfoliosTable < ActiveRecord::Migration
  def change
    create_table :project_portfolios do |t|
      t.integer      :user_id
      t.integer      :parent_id
      t.string       :client
      t.integer      :year
      t.text         :about_me
      t.timestamps
    end
  end
end