class AddColumnToCompanyAvatar < ActiveRecord::Migration
  def up
    add_attachment :company_avatar, :image
  end
end