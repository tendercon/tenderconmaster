class RemoveColumnFromTenders < ActiveRecord::Migration
  def change
    remove_column :tenders, :job_value
    remove_column :tenders, :trade_id
    remove_column :tenders, :photo_file_name
    remove_column :tenders, :photo_content_type
    remove_column :tenders, :photo_file_size
    remove_column :tenders, :photo_updated_at

    remove_column :tenders, :document_file_name
    remove_column :tenders, :document_content_type
    remove_column :tenders, :document_file_size
    remove_column :tenders, :document_updated_at


    change_column :tenders, :description, :text

    add_column :tenders, :suburb, :string
    add_column :tenders, :address_terms, :string
    add_column :tenders, :client, :string
    add_column :tenders, :category_id, :integer
    add_column :tenders, :architect, :string
    add_column :tenders, :tender_value_id, :integer
    add_column :tenders, :status, :string
  end
end
