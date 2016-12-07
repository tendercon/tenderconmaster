class CreateAddendas < ActiveRecord::Migration
  def change
    create_table :addendas do |t|
      t.integer :tender_id
      t.integer :user_id
      t.string  :subject
      t.string  :ref_no
      t.text    :details
      t.timestamps null: false
    end
  end
end
