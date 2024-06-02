require "rails_helper"

RSpec.describe "booking_dates", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "GET /booking_date" do
    before do
      visit booking_date_path
      if Date.today.wday == 0
        click_link("次週")
      end
    end

    it 'should show next week if click 次週' do
      click_link("次週")
      expect(page).to have_text('○', count: 27 * 7)
    end

    it "should get booking_date_new_path correct information" do
      row = all('tbody tr')[1]
      row.all('a', text: '○')[0].click
      day_value = find('#booking_date_day').value
      time_value = find('#booking_date_time').value
      expect(day_value).to eq("#{Date.tomorrow.to_s}")
      expect(time_value).to eq("8:00")
    end

    it 'should show correct inform if random pacth' do
      booking_new_rand
      day_value = find('#booking_date_day').value
      time_value = find('#booking_date_time').value
      expect(day_value).to eq("#{@week_test.to_s}")
      expect(time_value).to eq("#{@time_test}")
    end
  end
end