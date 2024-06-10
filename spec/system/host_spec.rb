require "rails_helper"

RSpec.describe "booking_dates", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    host = FactoryBot.create(:host)
  end

  describe 'GET /booking/host' do
    it 'shuold login correct information' do
      visist booking_host_path
      fill_in 'password', with: 'password' 

      click_button 'ログイン'

      expect(page).to have_content('予約確認')
    end
  end

  describe 'GET /host/index' do
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

    it 'should render host_new_path correct information' do
      row = all('tbody tr')[1]
      row.all('a', text: '○')[0].click
      day_value =  find()
      time_value = find()
      expect(day_value).to eq("#{Date.tomorrow.to_s}")
      expect(time_value).to eq("8:00")
    end


  end

  describe 'GET /host/new' do
    before do
      visit host_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")
    end

    context 'correct information' do
      it 'should save correct information' do
      end
    end
  end
end