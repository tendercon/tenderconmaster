class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :document_package_id
      t.string  :code
      t.timestamps null: false
    end
  end
end
