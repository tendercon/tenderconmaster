class AddColumnToSites < ActiveRecord::Migration
  def change
    add_column :sites, :section_title_trusted_by_smart, :string
    add_column :sites, :section_intro_trusted_by_smart, :text
    add_column :sites, :quote_intro, :text
    add_column :sites, :quote_name, :string
    add_column :sites, :quote_title, :string
    add_column :sites, :quote_intro2, :text
    add_column :sites, :quote_name2, :string
    add_column :sites, :quote_title2, :string

    add_attachment :sites, :quote_profile
    add_attachment :sites, :quote_profile2
  end
end
