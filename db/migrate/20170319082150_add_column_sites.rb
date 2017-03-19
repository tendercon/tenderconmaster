class AddColumnSites < ActiveRecord::Migration
  def change
    add_column :sites, :page_type, :string
    add_column :sites, :header_headline, :text
    add_column :sites, :header_tagline, :text
    add_column :sites, :section_title, :text
    add_column :sites, :section_intro, :text
    add_column :sites, :item_title, :text
    add_column :sites, :item_desc, :text
    add_column :sites, :item_title1, :text
    add_column :sites, :item_desc1, :text
    add_column :sites, :item_title2, :text
    add_column :sites, :item_desc2, :text
  end
end
