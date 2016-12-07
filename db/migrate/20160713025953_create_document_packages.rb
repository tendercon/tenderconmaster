class CreateDocumentPackages < ActiveRecord::Migration
  def change
    create_table :document_packages do |t|
      t.integer :tender_id
      t.integer :user_id
      t.text  :path
      t.timestamps null: false
    end
  end
end
