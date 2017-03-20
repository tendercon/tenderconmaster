class AddCompanyImages < ActiveRecord::Migration
  def change
    add_attachment :company_pages, :ceo_avatar
    add_attachment :company_pages, :co_founder_avatar

  end
end
