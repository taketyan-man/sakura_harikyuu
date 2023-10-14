class AddColumnName < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :name, :string
  end
end
