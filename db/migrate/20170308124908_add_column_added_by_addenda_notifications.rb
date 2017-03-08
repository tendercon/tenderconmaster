class AddColumnAddedByAddendaNotifications < ActiveRecord::Migration
  def change
    add_column(:addenda_notifications, :added_by, :string)
  end
end
