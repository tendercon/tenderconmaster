class AddColumnsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :product_header, :string
    add_attachment :sites, :product_image1
    add_attachment :sites, :product_image2
    add_attachment :sites, :product_image3
    add_attachment :sites, :product_image4
  end
end
