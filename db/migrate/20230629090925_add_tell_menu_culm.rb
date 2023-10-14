class AddTellMenuCulm < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :tell, :string
  end
end
