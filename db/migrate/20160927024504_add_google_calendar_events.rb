class AddGoogleCalendarEvents < ActiveRecord::Migration
  def change
    add_column :google_calendar_events, :start_date,  :datetime
    add_column :google_calendar_events, :end_date,  :datetime
  end
end
