class AddOptionToBookingDate < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :option, :integer
  end
end
