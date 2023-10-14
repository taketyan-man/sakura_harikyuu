class AddColumMenu < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :menu, :integer
  end
end
