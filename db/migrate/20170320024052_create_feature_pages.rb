class CreateFeaturePages < ActiveRecord::Migration
  def change
    create_table :feature_pages do |t|
      t.string  :page_type
      t.text  :headline
      t.text  :tagline
      t.string  :feature_block_1
      t.string  :feature_block_2
      t.string  :feature_block_3
      t.string  :feature_block_4
      t.text  :feature_title
      t.text  :feature_desc
      t.text  :feature_title2
      t.text  :feature_desc2
      t.text  :feature_title3
      t.text  :feature_desc3
      t.text  :feature_title4
      t.text  :feature_desc4
      t.timestamps null: false
    end
  end
end
