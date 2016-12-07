class AddColumnQuotesTable < ActiveRecord::Migration
  def change
    add_column(:quotes, :title, :string)
    add_column(:quotes, :version, :string)
  end
end
