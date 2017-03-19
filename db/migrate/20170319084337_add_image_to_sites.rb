class AddImageToSites < ActiveRecord::Migration
  def change
    add_attachment :sites, :section_image1
    add_attachment :sites, :section_image2
    add_attachment :sites, :section_image3
    add_attachment :sites, :item_image1
    add_attachment :sites, :item_image2
    add_attachment :sites, :item_image3
    add_attachment :sites, :key_feature_image1

  end
end
