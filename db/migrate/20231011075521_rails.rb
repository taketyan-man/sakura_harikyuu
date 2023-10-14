class Rails < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :s_time, :strig
    add_column :booking_dates, :e_time, :strig
  end
end
