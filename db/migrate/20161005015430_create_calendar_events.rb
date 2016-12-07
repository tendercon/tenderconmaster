class CreateCalendarEvents < ActiveRecord::Migration
  def change
    create_table :calendar_events do |t|
      t.integer :user_id
      t.string  :title
      t.string  :description
      t.string  :category
      t.datetime  :event_date
      t.string  :timezone
      t.string  :repeat
      t.timestamps null: false
    end
  end
end
