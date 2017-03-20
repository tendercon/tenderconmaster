class CreateContactPages < ActiveRecord::Migration
  def change
    create_table :contact_pages do |t|
      t.text  :headline
      t.text  :meta
      t.string  :form_title
      t.string  :name
      t.text    :email
      t.string  :message
      t.text  :sent_it
      t.timestamps null: false
    end
  end
end
