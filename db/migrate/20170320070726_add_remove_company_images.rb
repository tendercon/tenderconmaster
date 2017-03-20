class AddRemoveCompanyImages < ActiveRecord::Migration
  def change
    add_attachment :company_pages, :team3_avatar
    add_attachment :company_pages, :team4_avatar
    add_attachment :company_pages, :team5_avatar
    add_attachment :company_pages, :team6_avatar
    add_attachment :company_pages, :team7_avatar
    add_attachment :company_pages, :team8_avatar

  end
end
