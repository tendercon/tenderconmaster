class AddImageToHeaderNavs < ActiveRecord::Migration
  def change
    add_attachment :header_navs, :logo
  end
end
