class AddDayTime < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :date_time, :string
  end
end
