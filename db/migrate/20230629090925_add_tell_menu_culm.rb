class AddTellMenuCulm < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_dates do |t|
    end
    add_column :booking_dates, :tell, :string
    add_column :booking_dates, :day, :date
    add_column :booking_dates, :time, :string
    add_column :booking_dates, :menu, :integer
    add_column :booking_dates, :date_time, :string
    add_column :booking_dates, :name, :string
    add_column :booking_dates, :s_time,:string
    add_column :booking_dates, :e_time, :string
    add_column :booking_dates, :option, :integer
    add_column :booking_dates, :start_time, :string
  end
end
