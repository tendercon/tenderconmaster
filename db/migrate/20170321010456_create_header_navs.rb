class CreateHeaderNavs < ActiveRecord::Migration
  def change
    create_table :header_navs do |t|
      t.string  :page_type
      t.string  :home
      t.string  :feature
      t.string  :pricing
      t.string  :company
      t.string  :login
      t.string  :register
      t.boolean :hide_pricing, :default => true
      t.timestamps null: false
    end
  end
end
