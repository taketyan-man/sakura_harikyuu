class AddReservationToBookingDate < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :day, :date
    add_column :booking_dates, :time, :string
  end
end
