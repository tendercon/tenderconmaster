class CreateAddendaChanges < ActiveRecord::Migration
  def change
    create_table :addenda_changes do |t|

        t.integer :addenda_id
        t.string  :previous_date
        t.string  :previous_status
        t.timestamps null: false

    end
  end
end
