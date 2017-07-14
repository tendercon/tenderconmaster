class AddNumberOfYearsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :experience , :string
  end
end
