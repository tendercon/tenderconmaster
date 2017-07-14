class AddColumnToCompanyProfiles < ActiveRecord::Migration
  def change
  	add_column :company_profiles, :twitter, :text
  	add_column :company_profiles, :contact, :string
  	add_column :company_profiles, :position, :integer
  	add_column :company_profiles, :email, :string
  end
end
