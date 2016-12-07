class AddColumnToCompanyProfile < ActiveRecord::Migration
  def change
    add_column :company_profiles, :acn, :string
  end
end