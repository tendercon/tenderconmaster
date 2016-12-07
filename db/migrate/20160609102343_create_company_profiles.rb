class CreateCompanyProfiles < ActiveRecord::Migration
  def change
    create_table :company_profiles do |t|
      t.integer :user_id
      t.text :about_me
      t.integer :number_of_employees
      t.integer :commenced_operation
      t.integer :since
      t.string :contact_number
      t.string :fax_number
      t.string :website
      t.string :linkedin
      t.string :facebook
      t.string :project_range
      t.timestamps null: false
    end
  end
end