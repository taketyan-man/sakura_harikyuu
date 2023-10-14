class ChangeDatatypeTimeOfBooking < ActiveRecord::Migration[7.0]
  def change
    change_column :booking_dates, :start_time, :datetime
    change_column :booking_dates, :end_time, :datetime
  end
end
