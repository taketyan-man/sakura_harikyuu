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

    it 'should show correct information if 予約確認' do
      visit host_path
      elements = all('.host-nav')
      elements[1].click
      expect(find('.bookingCheckBox').text).to be_empty
      reservation()
      visit host_path
      elements = all('.host-nav')
      elements[1].click
      expect(find('.bookingCheckBox').text).to_not be_empty
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

        fill_in 's_time_hour', with: '08'.to_i
        fill_in 's_time_minute', with: '00'.to_i
        fill_in 'e_time_hour', with: '12'.to_i
        fill_in 'e_time_minute', with: '00'.to_i

        click_button '予定を入れる'

        expect(page.body).to include("予定入力しました。")
      end
    end
  end

  describe 'GET /host/show' do
    before do
      host_is
      if Date.today.wday == 0
        click '次週'
      end
      reservation()
      visit host_path
      row = all('tbody tr')[1]
      row.all('a', text: '予約あり')[0].click
    end

    it 'should show booking of information correctly if booking' do
      expect(page.body).to include('予約詳細')
      expect(page.body).to include('テスト')
      expect(page.body).to include('0' * 11)
      expect(page.body).to include('ボディケア 120分')
      expect(page.body).to include('アロマオイル 20分')

      click_link '戻る'
      expect(page.body).to include('予定入力')
    end

    it 'should show deletebox' do
      expect(page).to have_css('div.delete-box', visible: false)
      find('#delete-btn').click
      expect(page).to have_css('div.delete-box', visible: true)
      find('#delete-content-out').click
      expect(page).to have_css('div.delete-box', visible: false)
    end

    it 'should delete booking if correct' do
      find('#delete-btn').click
      deltebtn = find('#host_button')
      expect(page).to have_button('削除', disabled: true)
      checkbox = find('#delete_check')
      checkbox.click
      expect(page).to have_button('削除', disabled: false)
      deltebtn.click
      expect(page.body).to include('予約は削除されました。')
    end
    
  end
end