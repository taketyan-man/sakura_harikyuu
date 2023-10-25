class Rails < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :s_time,:string
    add_column :booking_dates, :e_time, :string
  end
end
