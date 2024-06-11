require "rails_helper"

RSpec.describe "booking_dates", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    host = FactoryBot.create(:host)
  end

  describe 'GET /booking/host' do
    it 'shuold login correct information' do
      visit booking_host_path
      fill_in 'session_password', with: 'password' 

      click_button 'ログイン'

      expect(page).to have_content('予約確認')
    end
  end

  describe 'GET /host/index' do
    before do
      host_is
      if Date.today.wday == 0
        click_link("次週")
      end
    end

    it 'should show next week if click 次週' do
      click_link("次週")
      expect(page).to have_text('○', count: 27 * 7)
    end

    it 'should show 予約あり if booking' do
      reservation()
      visit host_path
      expect(page.body).to include('予約あり')
    end
  end

  describe 'GET /host/new' do
    before do
      host_is
      visit host_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")
    end

    context 'correct information' do
      it 'should show correctly' do
        visit host_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")
        expect(page.body).to include('予定入力')
      end

      it 'should save correct information' do
        visit host_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")

        fill_in 's_time_hour', with: '08'
        fill_in 's_time_minute', with: '00'
        fill_in 'e_time_hour', with: '12'
        fill_in 'e_time_minute', with: '00'

        click_button '予定を入れる'

        expect(flash[:success]).to eq(["予定入力しました。"])
      end
    end
  end

  describe 'GET /host/show' do
    before do
      host_is
      if Date.today.wday == 0
        click '次週'
      end
    end

    it 'should show booking of information correctly if booking' do
      reservation()
      visit host_path
      row = all('tbody tr')[1]
      row.all('a', text: '予約あり')[0].click
      
    end
  end
end