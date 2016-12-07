class AddColumnToTenders < ActiveRecord::Migration
  def up
    add_attachment :tenders, :photo
    add_attachment :tenders, :document
  end

end