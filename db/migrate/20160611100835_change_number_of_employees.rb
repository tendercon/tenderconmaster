class ChangeNumberOfEmployees < ActiveRecord::Migration
  def change
    change_column :company_profiles, :number_of_employees, :string
  end
end