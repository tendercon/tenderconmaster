class CreateGoogleCalendarEvents < ActiveRecord::Migration
  def change
    create_table :google_calendar_events do |t|
      t.integer :user_id
      t.text    :token
      t.string  :email
      t.string  :summary
      t.timestamps :start_date
      t.timestamps :end_date
      t.timestamps null: false
    end
  end
end
