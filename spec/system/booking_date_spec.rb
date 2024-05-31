require "rails_helper"

RSpec.describe "booking_dates", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "GET /booking_date" do
    before do
      visit booking_date_path
    end

    it "should get booking_date_new_path correct information" do
      row = all('tbody tr')[1]
      row.all('a', text: '○')[0].click
      day_value = find('#booking_date_day').value
      time_value = find('#booking_date_time').value
      expect(day_value).to eq("#{Date.tomorrow.to_s}")
      expect(time_value).to eq("8:00")
    end
  end
end