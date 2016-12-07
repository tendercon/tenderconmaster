class CreateRfis < ActiveRecord::Migration
  def change
    create_table :rfis do |t|
      t.integer :user_id
      t.string  :ref_no
      t.string  :to
      t.string  :attention
      t.datetime :rfi_date
      t.datetime :response_date
      t.string  :heading
      t.string  :description
      t.integer :trade_id
      t.timestamps null: false
    end
  end
end
