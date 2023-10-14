class ChangeDataStimeAndEtimeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :booking_dates, :start_time, :string
    change_column :booking_dates, :end_time, :string
  end
end
