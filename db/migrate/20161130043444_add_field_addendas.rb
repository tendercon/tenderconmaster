class AddFieldAddendas < ActiveRecord::Migration
  def change
    add_column(:addendas, :sent, :datetime)
    add_column(:addendas, :type, :string)
  end
end
