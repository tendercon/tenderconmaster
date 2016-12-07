class CreateTableTimeAvailability < ActiveRecord::Migration
  def change
    create_table :time_availabilities do |t|
      t.string :availability
      t.timestamps null: false
    end
  end
end