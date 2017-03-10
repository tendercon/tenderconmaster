class AddSeenColumnToQuotes < ActiveRecord::Migration
  def change
    add_column(:quotes, :seen, :boolean, :default => false)
  end
end
